#include<bits/stdc++.h>
#include "sym_tab.hpp"
#include "utils.hpp"

using namespace std;


extern vector<string> nodes;
extern vector<int> line_no;
extern vector<vector<int>> adj;
extern int node_count;

extern vector<string> nodes_copy;
extern vector<vector<int>> adj_copy;

extern map<int, int> node_prod;
extern map<int,node_attr> node_attr_map;


extern vector<map<string, map<string, string>>> sym_tab;
extern map<int, int> parent;
extern map<int, vector<int>> children;
extern map<string, int> class_map;
extern map<int, string> class_map_2;
extern map<int, int> node_to_sym_tab;
extern map<int, pair<string, int>> node_to_type;
extern vector<vector<pair<string, map<string, string>>>> func_params;
extern int curr_sym_tab;
extern int func_param_ind;
extern map<int,int> parse_to_ast;

extern string return_reg;

void postorder_3AC(int n){
    int reducer = node_prod[n];
     string name = nodes[n];
     if(name == "Literal"){
          node_attr_map[n].variable = get_new_temp();
          node_attr_map[n].val = nodes[adj[adj[n][0]][0]];
          node_attr_map[n].code = node_attr_map[n].variable + " = " + node_attr_map[n].val + "\n";
          switch(reducer){
               case 0:
                    node_attr_map[n].type = "int";
                    node_attr_map[n].size = 4;
                    break;
               case 1:
                    node_attr_map[n].type = "float";
                    node_attr_map[n].size = 8;
                    break;
               case 2:
                    node_attr_map[n].size = 2;
                    break;
               case 3:
                    node_attr_map[n].size = 2048;
                    break;
               case 4:
                    node_attr_map[n].size = 2048;
                    break;
               case 5:
                    node_attr_map[n].size = 1;
                    break;
               case 6:
                    node_attr_map[n].size = 1;
                    break;
          }
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code += node_attr_map[n].label;
          node_attr_map[n].code += " : ";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you in  literal\n";
          return;
     }
     if (name == "Type"){
          node_attr_map[n].size = node_attr_map[adj[n][0]].size;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
          if (name == "PrimitiveType"){
          switch (reducer){
               case 0:
                    node_attr_map[n].size = node_attr_map[adj[n][0]].size;
                    break;
               case 1:
                    node_attr_map[n].size = 1;
                    break;
               case 2:
                    node_attr_map[n].size = 8;
                    break;

          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "NumericType"){
          node_attr_map[n].size = node_attr_map[adj[n][0]].size;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "IntegralType"){
          switch (reducer){
               case 0:
                    node_attr_map[n].size = 1;
                    break;
               case 1:
                    node_attr_map[n].size = 2;
                    break;
               case 2:
                    node_attr_map[n].size = 4;
                    break;
               case 3:
                    node_attr_map[n].size = 8;
                    break;
               case 4:
                    node_attr_map[n].size = 2;
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "FloatingPointType"){
          switch (reducer){
               case 0:
                    node_attr_map[n].size = 4;
                    break;
               case 1:
                    node_attr_map[n].size = 8;
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ReferenceType"){
          node_attr_map[n].size = node_attr_map[adj[n][0]].size;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ClassOrInterfaceType"){
          node_attr_map[n].type = node_attr_map[adj[n][0]].variable;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ClassType"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InterfaceType"){
          node_attr_map[n].size = -1;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ArrayType"){
          node_attr_map[n].size = -1;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "Name"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
           string type = var_data_type(node_to_type[parse_to_ast[n]].first);
          if(type == "integer") {
               node_attr_map[n].type = "int";
          }
          else if(type == "decimal"){
          node_attr_map[n].type = "float";}
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
     //    cout<< type << " " << node_attr_map[n].variable << " " << node_attr_map[n].size << endl;
          return;
     }
     if (name == "SimpleName"){
          node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "QualifiedName"){
          node_attr_map[n].variable = node_attr_map[adj[n][0]].variable + "." + nodes[adj[adj[n][2]][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "CompilationUnit"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ImportDeclarations"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "TypeDeclarations"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "PackageDeclaration"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SingleTypeImportDeclaration"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "TypeImportOnDemandDeclaration"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "TypeDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "MethodTypeDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "Modifiers"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "Modifier"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ClassDeclaration"){
          string class_name;
          string extension = ".class\n";
          switch(reducer){
               case 0: 
                    class_name = nodes[adj[adj[n][2]][0]];
                    break;
               case 1:
                    class_name = nodes[adj[adj[n][1]][0]];
                    break;
               case 2:
                    class_name = nodes[adj[adj[n][2]][0]];
                    break;
               case 3:
                    class_name = nodes[adj[adj[n][2]][0]];
                    break;
               case 4:
                    class_name = nodes[adj[adj[n][1]][0]];
                    break;
               case 5:
                    class_name = nodes[adj[adj[n][1]][0]];
                    break;
               case 6:
                    class_name = nodes[adj[adj[n][2]][0]];
                    break;
               case 7:
                    class_name = nodes[adj[adj[n][1]][0]];
                    break;
          }
          class_name = class_name + extension;
          node_attr_map[n].code = class_name;
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].code  += "endclass\n";
          return;     
     }
     if (name == "Super") {
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "Interfaces"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InterfaceTypeList"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          return;          
     }
     if (name == "ClassBody"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ClassBodyDeclarations"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }   
     if (name == "ClassBodyDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }  
     if (name == "ClassMemberDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }  
     if (name == "FieldDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                         node_attr_map[n].label = node_attr_map[adj[n][2]].label;
                         break;
               case 1:   
                         node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                         break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }  
     if (name == "VariableDeclarators"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code += node_attr_map[n].label;
          node_attr_map[n].code += " : ";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }  
     if (name == "VariableDeclarator"){
          switch(reducer){
               case 0:
                    break;
               case 1:
                    string var0 = node_attr_map[adj[n][0]].variable;   
                    string var1 = node_attr_map[adj[n][2]].variable;
                    string code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    if (!node_attr_map[adj[n][2]].dims.empty()){
                         int sym_ind = var_sym(node_to_sym_tab[parse_to_ast[n]], var0, parse_to_ast[n]);
                         string prev_temp = "";

                         for (int ii = 0; ii < node_attr_map[adj[n][2]].dims.size(); ii++){
                              // code += "add symboltable(" + var0 + "." + "dim" + to_string(ii) + "," + node_attr_map[adj[n][2]].dims[ii] + ")\n";
                              sym_tab[sym_ind][var0]["dim" + to_string(ii)] = node_attr_map[adj[n][2]].dims[ii];
                              
                              if(ii == 0) {
                                   prev_temp = node_attr_map[adj[n][2]].dims[ii];
                              }
                              else {
                                   string temp = get_new_temp();
                                   code += temp + " = " + prev_temp + "*" + node_attr_map[adj[n][2]].dims[ii] + "\n";
                                   prev_temp = temp;
                              }
                         }
                         string temp = get_new_temp();
                         code += temp + " = " + prev_temp + "*" + to_string(get_type_size(sym_tab[sym_ind][var0]["Type"])) + "\n";

                         code +="call allocmem " + temp + "\n";
                         code += var0 + " = pop stack\n";
                         // add all dimensions
          
                    }
                    else{
                         code += var0 + " = " + var1 + "\n";
                    }
                    // if (!node_attr_map[adj[n][2]].dims.empty()){
                    //      code += "add symtable(" + var0 + ", " + var1 + ".dims)\n";
                    // }
                    node_attr_map[n].code = code;
                    break;
          }
          // cout << node_attr_map[n].code;

          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     } 
     if (name == "VariableDeclaratorId"){
          switch(reducer){
               case 0:
                    node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                    break;
               case 1:
                    node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "VariableInitializer"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MethodDeclaration"){
          int frame_size = 56; 
          switch(reducer){
               case 0:
                    string code = "func " + node_attr_map[adj[n][0]].variable + "\n";
                    frame_size += get_func_size(node_attr_map[adj[n][0]].variable, parse_to_ast[n]);
                    code += "move8 rbp -8(rsp)\n";
                    code += "rbp = rsp\n"; 
                    code += node_attr_map[adj[n][0]].code;
                    code += "sub rsp, $" + to_string(frame_size) + "\n";
                    code += "move48 regs -56(rbp)\n";
                    code += node_attr_map[adj[n][1]].code;
                    code += "move48 -56(rbp) regs\n";
                    code += "move8 rbp rsp\n";
                    code += "move8 -8(rbp) rbp\n";
                    code += "move8 RRE -8(rsp)\n";
                    code += "sub rsp, $8\n";
                    node_attr_map[n].code = code;
                    node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
                    node_attr_map[n].code = node_attr_map[n].code + "ret\nendfunc\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
    
     if (name == "MethodHeader"){
        switch(reducer){
            case 0:
                    node_attr_map[n].variable = node_attr_map[adj[n][2]].variable;
                    break;
          case 1:
                    node_attr_map[n].variable = node_attr_map[adj[n][2]].variable;
                    break;
          case 2:
                    node_attr_map[n].variable = node_attr_map[adj[n][1]].variable;
                    break;
           case 3:
                    node_attr_map[n].variable = node_attr_map[adj[n][2]].variable;
                    break;
           case 4:
                    node_attr_map[n].variable = node_attr_map[adj[n][1]].variable;
                    break;
           case 5:
                    node_attr_map[n].variable = node_attr_map[adj[n][1]].variable;
                    break;
           case 6:
                    node_attr_map[n].variable = node_attr_map[adj[n][2]].variable;
                    break;
          case 7:
                    node_attr_map[n].variable = node_attr_map[adj[n][1]].variable;
                    break;    
        }
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }
     if (name == "MethodDeclarator"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          int curr = 0;
          switch(reducer){
               case 0:
                    node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                    if (node_attr_map[n].variable == "main"){
                         break;
                    }
                    for (int i = 0; i < node_attr_map[adj[n][2]].sizes.size(); i++){
                         // cout << node_attr_map[adj[n][2]].sizes[i] << endl;
                         node_attr_map[n].code += "move" + to_string(node_attr_map[adj[n][2]].sizes[i]); 
                         node_attr_map[n].code += string(" ") + to_string(curr) + "(rbp) " + node_attr_map[adj[n][2]].args[i] + "\n";
                         curr += node_attr_map[adj[n][2]].sizes[i];
                         //cout << curr << endl;
                    }
                    break;
               case 1:
                    node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                    break;
               case 2:
                    node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "FormalParameterList"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                    node_attr_map[n].sizes = node_attr_map[adj[n][0]].sizes;
                    node_attr_map[n].args = node_attr_map[adj[n][0]].args;
                    break;
               case 1:
                    node_attr_map[n].sizes = node_attr_map[adj[n][0]].sizes;
                    node_attr_map[n].args = node_attr_map[adj[n][0]].args;
                    node_attr_map[n].sizes.push_back(node_attr_map[adj[n][2]].sizes[0]);
                    node_attr_map[n].args.push_back(node_attr_map[adj[n][2]].args[0]);
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "FormalParameter"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          //cout<<"Hello\n";
          switch(reducer){
               case 0:
                    node_attr_map[n].sizes.push_back(node_attr_map[adj[n][0]].size);
                    node_attr_map[n].args.push_back(node_attr_map[adj[n][1]].variable);
                    break;
               case 1:
                    node_attr_map[n].sizes.push_back(node_attr_map[adj[n][1]].size);
                    node_attr_map[n].args.push_back(node_attr_map[adj[n][2]].variable);
                    break;
          }
          // cout << node_attr_map[n].code;
          return;
     }

     if (name == "Throws"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ClassTypeList"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MethodBody"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }

          // node_attr_map[n].code += "nop\npop rbp\n";

          node_attr_map[n].code += "nop\n";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "StaticInitializer"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ConstructorDeclaration"){
          string code = "constructor\n";
          code += "move8 this 0(rbp)\n";
          for (int i = 0; i < adj[n].size(); i++) {
               code = code + node_attr_map[adj[n][i]].code;
          }
          code = code + "endconstructor\n";
          node_attr_map[n].code = code;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ConstructorDeclarator"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          int curr = 0;
          switch(reducer){
               case 1:
                    node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                    for (int i = 0; i < node_attr_map[adj[n][2]].sizes.size(); i++){
                         // cout << node_attr_map[adj[n][2]].sizes[i] << endl;
                         node_attr_map[n].code += "move" + to_string(node_attr_map[adj[n][2]].sizes[i] + 8); 
                         node_attr_map[n].code += string(" ") + to_string(curr) + "(rbp) " + node_attr_map[adj[n][2]].args[i] + "\n";
                         curr += node_attr_map[adj[n][2]].sizes[i];
                         //cout << curr << endl;
                    }
                    break;
               case 0:
                    node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ConstructorBody"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ExplicitConstructorInvocation"){
          // Parinay: This and super are for inheritance and blah blah blah hence ignored
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "InterfaceDeclaration"){       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ExtendsInterfaces"){       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InterfaceBody"){       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InterfaceMemberDeclarations"){       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InterfaceMemberDeclaration"){       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ConstantDeclaration"){
          node_attr_map[n] = node_attr_map[adj[n][0]];       
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "AbstractMethodDeclaration"){
           switch(reducer){
               case 0:
                    string code = "func" + node_attr_map[adj[n][0]].variable + "\n" + node_attr_map[adj[n][0]].code + node_attr_map[adj[n][1]].code + "endfunc\n";
                    node_attr_map[n].code = code;
                    // node_attr_map[n].variable = node_atVariableInitializer:tr_map[adj[n][0]].variable;
                    break;
          }     
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ArrayInitializer"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][1]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][1]];
                    break;
               case 2:
                    node_attr_map[n].variable = get_new_temp();
                    break;
               case 3:
                    node_attr_map[n].variable = get_new_temp();
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "VariableInitializers"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].size = node_attr_map[adj[n][0]].size + node_attr_map[adj[n][2]].size;
                    string temp = get_new_temp();
                    node_attr_map[n].code += temp + " = " + node_attr_map[n].variable + " + " + to_string(node_attr_map[n].size) + "\n";
                    node_attr_map[n].code += "*" + temp + " = " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "Block"){
          switch(reducer){
               case 0:
                    node_attr_map[n].label = get_new_label();
                    node_attr_map[n].code = node_attr_map[n].label + " : ";
                    break;
               case 1:
                    node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                    node_attr_map[n].code = node_attr_map[adj[n][1]].code;
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }     
     if (name == "BlockStatements"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = node_attr_map[adj[n][adj[n].size()-1]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "BlockStatement"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MethodBlock"){
          switch(reducer){
               case 0:
                    node_attr_map[n].label = get_new_label();
                    node_attr_map[n].code = node_attr_map[n].label + " : ";
                    break;
               case 1:
                    node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                    node_attr_map[n].code = node_attr_map[adj[n][1]].code;
                    break;
          }
         // cout << node_attr_map[n].code << endl;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MethodBlockStatements"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = node_attr_map[adj[n][adj[n].size()-1]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MethodBlockStatement"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "LocalVariableDeclarationStatement"){  
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "LocalVariableDeclaration"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                    node_attr_map[n].type = node_attr_map[adj[n][0]].type;
                    node_attr_map[n].size = node_attr_map[adj[n][0]].size;
                    break;
               case 1:
                    node_attr_map[n].type = node_attr_map[adj[n][1]].type;
                    node_attr_map[n].size = node_attr_map[adj[n][1]].size;
                    break;
          }
          node_attr_map[n].label = node_attr_map[adj[n][adj[n].size()-1]].label;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "VariableModifier"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "Statement"){
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;                    
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "StatementNoShortIf"){
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;        
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "StatementWithoutTrailingSubstatement"){
          node_attr_map[n].label = node_attr_map[adj[n][0]].label;
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;        
          // cout << "PostIncrementexpression\n" << node_attr_map[n].code << "kahtm\n";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "EmptyStatement"){
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code = node_attr_map[n].label + " : ";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "LabeledStatement"){
          // pick label from symbol table
          node_attr_map[n].label = node_attr_map[adj[n][2]].label;
          node_attr_map[n].code = nodes[adj[adj[n][0]][0]]+ " : " +node_attr_map[adj[n][2]].code;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "LabeledStatementNoShortIf"){
          // pick label from symbol table
          node_attr_map[n].label = node_attr_map[adj[n][2]].label;
          node_attr_map[n].code = nodes[adj[adj[n][0]][0]]+ " : " +node_attr_map[adj[n][2]].code;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ExpressionStatement"){
          node_attr_map[n].variable = get_new_temp();
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[n].label + " : ";
          // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "StatementExpression"){
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;
          // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "IfThenStatement"){
          string label = get_new_label();
          node_attr_map[n].label = node_attr_map[adj[n][4]].label;
          node_attr_map[n].code = node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " goto " + label + "\n" + "goto " + node_attr_map[adj[n][4]].label + "\n" + label + " : " + node_attr_map[adj[n][4]].code;                  
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "IfThenElseStatement"){
         string label1 = get_new_label();
         string label2 = get_new_label();

         node_attr_map[n].label = node_attr_map[adj[n][6]].label;

         node_attr_map[n].code = node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " goto " + label1 + "\n" + "goto " + label2 + "\n" + label1 + " : " + node_attr_map[adj[n][4]].code + "goto " + node_attr_map[adj[n][6]].label + "\n" + label2 + " : " + node_attr_map[adj[n][6]].code;                  
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "IfThenElseStatementNoShortIf"){
         string label1 = get_new_label();
         string label2 = get_new_label();

         node_attr_map[n].label = node_attr_map[adj[n][6]].label;
         
         node_attr_map[n].code = node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " goto " + label1 + "\n" + "goto " + label2 + "\n" + label1 + " : " + node_attr_map[adj[n][4]].code + "goto " + node_attr_map[adj[n][6]].label + "\n" + label2 + " : " + node_attr_map[adj[n][6]].code;                  
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SwitchStatement"){
          node_attr_map[n].label = node_attr_map[adj[n][4]].label;
          node_attr_map[n].code = node_attr_map[adj[n][2]].code + node_attr_map[adj[n][4]].code;

          while(node_attr_map[n].code.find("s-w-i-t-c-h") != string::npos)
               node_attr_map[n].code.replace(node_attr_map[n].code.find("s-w-i-t-c-h"), 11, node_attr_map[adj[n][2]].variable);

          while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
               node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, node_attr_map[n].label);
          return;

     }
     if (name == "SwitchBlock"){
          switch(reducer){
               case 0:
                         node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                         node_attr_map[n].code = node_attr_map[adj[n][1]].code;                         
                         break;
               case 1:
                         node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                         node_attr_map[n].code = node_attr_map[adj[n][1]].code;                         
                         break;   
               case 2:   
                         node_attr_map[n].label = get_new_label();
                         node_attr_map[n].code = node_attr_map[n].label + " : ";
                         break;
               case 3:
                         node_attr_map[n].label = get_new_label();
                         node_attr_map[n].code = node_attr_map[n].label + " : ";
                         break;
          }
     }
     if (name == "SwitchBlockStatementGroups"){
          for(auto i : adj[n]){
               if(node_attr_map[i].variable == "")
                    node_attr_map[n].code = node_attr_map[i].code + node_attr_map[n].code;
               else{
                    node_attr_map[n].code = node_attr_map[n].code + node_attr_map[i].code;
                    node_attr_map[n].label = node_attr_map[i].label;
               }
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SwitchBlockStatementGroup"){
          string label = get_new_label();
          string child_label = node_attr_map[adj[n][0]].label;
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;

          string variable = "";
          bool flag = false;
          
          for(int it = 0; it != child_label.size();it++){
               if(child_label[it] != ',')
                    variable.push_back(child_label[it]);
               else{
                    if(variable[0] == 't')
                         node_attr_map[n].code += string("if") + " s-w-i-t-c-h == " + variable + " goto " + label + "\n";
                    if(variable[0] == 'D')
                         flag = true;
                    variable = "";
               }
          }
          node_attr_map[n].code += "goto "; 
          node_attr_map[n].code += node_attr_map[adj[n][1]].label;
          node_attr_map[n].code += "\n";
          node_attr_map[n].code += label;
          node_attr_map[n].code += " : ";
          node_attr_map[n].code += node_attr_map[adj[n][1]].code;

          if(!flag)
               node_attr_map[n].label = node_attr_map[adj[n][1]].label;
          else{
               string new_label = get_new_label();
               string code = node_attr_map[adj[n][1]].code;
               while((code.size() != 0) && (*code.rbegin() != '\n'))
                    code.pop_back();
               node_attr_map[n].code += code;
               node_attr_map[n].code += new_label;
               node_attr_map[n].code += " : ";
               node_attr_map[n].label = new_label;
               node_attr_map[n].variable = "True";
          }
          // cout << "statgroup\n" << node_attr_map[n].code <<"\nfinish\n";
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SwitchLabels"){
          for(auto i : adj[n]){
               node_attr_map[n].label += (node_attr_map[i].label + ",");
               node_attr_map[n].code += (node_attr_map[i].code);
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SwitchLabel"){
          switch(reducer){
               case 0:   node_attr_map[n].label = node_attr_map[adj[n][1]].variable;
                         node_attr_map[n].code = node_attr_map[adj[n][1]].code;
                         break;

               case 1:   node_attr_map[n].label = string("D");
                         break;
          }
     }
     if (name == "WhileStatement"){
          string stat_label = get_new_label();
          string cond_label = get_new_label();
          node_attr_map[n].label = get_new_label();

          node_attr_map[n].code = cond_label + " : " + node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " goto " + stat_label + "\ngoto " + node_attr_map[n].label + "\n" + stat_label + " : " + node_attr_map[adj[n][4]].code + "goto " + cond_label + "\n" + node_attr_map[n].label + " : ";

          while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, cond_label);
          while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, node_attr_map[n].label);
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "WhileStatementNoShortIf"){
          string stat_label = get_new_label();
          string cond_label = get_new_label();
          node_attr_map[n].label = get_new_label();

          node_attr_map[n].code = cond_label + " : " + node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " goto " + stat_label + "\ngoto " + node_attr_map[n].label + "\n" + stat_label + " : " + node_attr_map[adj[n][4]].code + "goto " + cond_label + "\n" + node_attr_map[n].label + " : ";

          while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, cond_label);
          while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, node_attr_map[n].label);
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "DoStatement"){
          string label1 = get_new_label();
          string label2 = get_new_label();

          node_attr_map[n].label = label2;
          node_attr_map[n].code = label1 + " : " + node_attr_map[adj[n][1]].code + node_attr_map[adj[n][4]].code + "if " + node_attr_map[adj[n][4]].variable + " goto " + label1 + "\n" + label2 + " : ";

          while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, node_attr_map[adj[n][1]].label);
          while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
               node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, label2);

          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ForStatement"){
          string L1 = get_new_label();
          string L2 = get_new_label();
          string L3 = get_new_label();
          string code = "";
          // cout << "ForStatement\n";

          switch(reducer){
               case 0:          
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                          code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][8]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;
               case 1:   
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += "goto " + L1 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 2:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 3:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 4:
                         node_attr_map[n].label = get_new_label();
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][4]].code;
                         code += " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 5:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 6:
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += "goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 7:
                         node_attr_map[n].label = get_new_label();
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += L2 + " : ";
                         code += "goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;
          }
     }
     if (name == "ForStatementNoShortIf"){
          string L1 = get_new_label();
          string L2 = get_new_label();
          string L3 = get_new_label();
          string code = "";
          // cout << "ForStatement\n";

          switch(reducer){
               case 0:          
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                          code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][8]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;
               case 1:   
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += "goto " + L1 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 2:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 3:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][7]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][4]].code;
                         code += "if " + node_attr_map[adj[n][4]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 4:
                         node_attr_map[n].label = get_new_label();
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][4]].code;
                         code += " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 5:
                         node_attr_map[n].label = get_new_label();
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += node_attr_map[adj[n][3]].code;
                         code += "if " + node_attr_map[adj[n][3]].variable + " goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 6:
                         node_attr_map[n].label = get_new_label();
                         code = node_attr_map[adj[n][2]].code;
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][6]].code;
                         code += L2 + " : ";
                         code += "goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;

               case 7:
                         node_attr_map[n].label = get_new_label();
                         code += L1 + " : ";
                         code += node_attr_map[adj[n][5]].code;
                         code += L2 + " : ";
                         code += "goto " + L1 + "\n";
                         code += "goto " + L3 + "\n";
                         code += L3 + " : ";
                         node_attr_map[n].code = code;
                         while(node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                         while(node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                              node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                         break;
          }
     }
     if (name == "ForInit"){
          node_attr_map[n].code = node_attr_map[adj[n][0]].code;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ForUpdate"){
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code = node_attr_map[n].label + " : " + node_attr_map[adj[n][0]].code;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "StatementExpressionList"){
          for(auto i : adj[n])
               node_attr_map[n].code = (node_attr_map[i].code + "\n");
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "BreakStatement"){
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code = string("goto ") + "b-r-e-a-k" + "\n" + node_attr_map[n].label + " : ";
     }
     if (name == "ContinueStatement"){
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code = string("goto ") + "c-o-n-t-i-n-u-e" + "\n" + node_attr_map[n].label + " : ";
     }
     if (name == "ReturnStatement"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                    node_attr_map[n].variable = return_reg;
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][1]].variable + "\n";
                    break;
               case 1:
                    break;
          }
          node_attr_map[n].label = get_new_label();
          node_attr_map[n].code += node_attr_map[n].label;
          node_attr_map[n].code += " : ";
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ThrowStatement"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "SynchronizedStatement"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if(name == "TryStatement"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "Catches"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "CatchClause"){
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "Finally"){
          node_attr_map[n] = node_attr_map[adj[n][1]];
     }

     if (name == "Primary"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
     }
     if (name == "PrimaryNoNewArray"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].variable = "this";
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][1]];
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 4:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 5:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 6:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;               
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ClassInstanceCreationExpression"){
          node_attr_map[n].variable = get_new_temp();
          string t = get_new_temp();
          int class_size = get_class_size(node_attr_map[adj[n][1]].type);
          switch(reducer){
               case 0:
                    node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][1]].code;
                    node_attr_map[n].code += "call allocmem " + to_string(class_size) + "$\n";
                    node_attr_map[n].code += node_attr_map[n].variable + " = RRE \n";        
                    node_attr_map[n].code += "move8 " + node_attr_map[n].variable + " -8(rbp)\n";
                    node_attr_map[n].code += node_attr_map[adj[n][3]].code;
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][1]].code;
                    node_attr_map[n].code += "call allocmem " + to_string(class_size) + "$\n";
                    node_attr_map[n].code += node_attr_map[n].variable + " = RRE \n";  
                    node_attr_map[n].code += "move8 " + node_attr_map[n].variable + " -8(rbp)\n";
                    break;
          }
          node_attr_map[n].code += "call" + node_attr_map[adj[n][0]].variable + " " + node_attr_map[adj[n][1]].type + ".constructor\n";
          // cout << node_attr_map[n].code;
          return;
     }
     if (name == "ArgumentList"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                    node_attr_map[n].args.push_back(node_attr_map[adj[n][0]].variable);
                    break;
               case 1:
                    node_attr_map[n].args = node_attr_map[adj[n][0]].args;
                    node_attr_map[n].args.push_back(node_attr_map[adj[n][2]].variable);
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ArrayCreationExpression"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].size = node_attr_map[adj[n][1]].size;
                    node_attr_map[n].dims = node_attr_map[adj[n][2]].dims;
                    break;
               case 1:
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].size += node_attr_map[adj[n][1]].size;
                    node_attr_map[n].dims = node_attr_map[adj[n][2]].dims;
                    break;
               case 2:
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].size += node_attr_map[adj[n][1]].size;
                    node_attr_map[n].dims = node_attr_map[adj[n][2]].dims;
                    node_attr_map[n].dims.push_back("ZERO");
                    break;
               case 3:
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].size += node_attr_map[adj[n][1]].size;
                    node_attr_map[n].dims = node_attr_map[adj[n][2]].dims;
                    for (int i = 0; i < node_attr_map[adj[n][3]].dims.size(); i++) {
                         node_attr_map[n].dims.push_back(node_attr_map[adj[n][3]].dims[i]);
                    }
                    break;
               case 4:
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].size += node_attr_map[adj[n][1]].size;
                    node_attr_map[n].dims = node_attr_map[adj[n][2]].dims;
                    for (int i = 0; i < node_attr_map[adj[n][3]].dims.size(); i++) {
                         node_attr_map[n].dims.push_back(node_attr_map[adj[n][3]].dims[i]);
                    }
                    node_attr_map[n].dims.push_back("ZERO");
                    break;
          }
          
          // cout << node_attr_map[n].code;
          return;
     }
     if (name == "DimExprs"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          switch(reducer){
               case 0:
                    node_attr_map[n].dims = node_attr_map[adj[n][0]].dims;
                    break;
               case 1:
                    node_attr_map[n].dims = node_attr_map[adj[n][0]].dims;
                    node_attr_map[n].dims.push_back(node_attr_map[adj[n][1]].dims[0]);
                    break;
          }
          return;
     }
     if (name == "DimExpr"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].dims.push_back(node_attr_map[adj[n][1]].variable);
          return;
     }
     if (name == "Dims"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }
          node_attr_map[n].dims = node_attr_map[adj[n][0]].dims;
          node_attr_map[n].dims.push_back("ZERO");
          // cout << node_attr_map[n].code;
          return;
     }
     if (name == "FieldAccess"){
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }

          switch(reducer){
               case 0:
                    node_attr_map[n].variable = "this." + nodes[adj[adj[n][2]][0]];
                    break;
               case 1:
                    node_attr_map[n].variable = "*" + nodes[adj[adj[n][0]][0]] + "." + node_attr_map[adj[adj[n][1]][0]].variable;
                    break;
          }
          // cout << node_attr_map[n].code;
          return;
     }
     if (name == "MethodInvocation"){
          string code = "";
          for (int i = 0; i < adj[n].size(); i++) {
               code = code + node_attr_map[adj[n][i]].code;
          }

          int offset = 56; 
          switch(reducer){
               case 0:
                    offset += get_invoked_method_offset(node_attr_map[adj[n][0]].variable , parse_to_ast[n]);
                    break;
               case 1:
                    offset += get_invoked_method_offset(string("this." + adj[adj[n][2]][0]) , parse_to_ast[n]);
                    break;
               case 2:
                    offset += get_invoked_method_offset(string("super." + adj[adj[n][2]][0]) , parse_to_ast[n]);
                    break;
               case 4:
                    offset += get_invoked_method_offset(node_attr_map[adj[n][0]].variable , parse_to_ast[n]);
                    break;
               case 5:
                    offset += get_invoked_method_offset(string("this." + adj[adj[n][2]][0]) , parse_to_ast[n]);
                    break;
               case 6:
                    offset += get_invoked_method_offset(string("super." + adj[adj[n][2]][0]) , parse_to_ast[n]);
          }
          vector<string> types, args;
          int args_child;
          switch(reducer){
               case 0:
                //    code += "call " + node_attr_map[adj[n][0]].variable  + "\n";
                    args_child = 2;
                    break;         
               case 1:
                   // code += "call " + node_attr_map[adj[n][0]].variable + "." + nodes[adj[n][2]] + "\n";
                    args_child = 4;
                    break;
               case 2:
                  //  code += "call super." + nodes[adj[n][2]] + "\n";
                    args_child = 4;
                    break;
               case 3:
                  //  code += "call " + node_attr_map[adj[n][0]].variable  + "\n";
                    args_child = -1;
                    break;         
               case 4:
                 //   code += "call " + node_attr_map[adj[n][0]].variable + "." + nodes[adj[n][2]] + "\n";
                    args_child = -1;
                    break;
               case 5:
                    // code += "call super." + nodes[adj[n][2]] + "\n";
                    args_child = -1;
                    break;
          }
          if (args_child == -1){
               switch(reducer){
                    case 3:
                         code += "call " + node_attr_map[adj[n][0]].variable  + "\n";
                         args_child = -1;
                         break;         
               case 4:
                       code += "call " + node_attr_map[adj[n][0]].variable + "." + nodes[adj[adj[n][2]][0]] + "\n";
                         args_child = -1;
                         break;
               case 5:
                         code += "call super." + nodes[adj[n][2]] + "\n";
                         args_child = -1;
                         break;
               }
               node_attr_map[n].code = code;
               node_attr_map[n].variable = return_reg;
               return;
          }
          code += "sub rsp, $8\n";
          code += "move8 ra (rsp)\n";
          offset += 8;          
          types = get_params(parse_to_ast[n]);
          args = node_attr_map[adj[n][args_child]].args;
          vector<int> sizes;
          for (int i = 0; i < types.size(); i++) {
               sizes.push_back(get_type_size(types[i]));
          }
          int total = 0;
          for (int i = 0; i < sizes.size(); i++) {
               total += sizes[i];
          }
          code += "sub rsp, $" + to_string(total) + "\n";
          int curr = 0;
          for (int i = 0; i < args.size(); i++) {
               code += "move" + to_string(sizes[i]) + " " + args[i] + " -" + to_string(offset + total - curr) + "(rbp)\n";
               curr += sizes[i];
          }
          switch(reducer){
               case 0:
                    code += "call " + node_attr_map[adj[n][0]].variable  + "\n";
                    args_child = 2;
                    break;         
               case 1:
                    code += "call " + node_attr_map[adj[n][0]].variable + "." + nodes[adj[adj[n][2]][0]] + "\n";
                    args_child = 4;
                    break;
               case 2:
                    code += "call super." + nodes[adj[n][2]] + "\n";
                    args_child = 4;
                    break;
          }
          code += "reclaim return value\n";
          code += "add rsp, $" + to_string(total) + "\n";
          code += "move8 (rsp) ra\n";
          code += "add rsp, $8\n";
          node_attr_map[n].code = code;
          node_attr_map[n].variable = return_reg;
          // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
          // cout << node_attr_map[n].code;
          return;
     }
     if (name == "ArrayAccess"){
          node_attr_map[n].type = node_attr_map[adj[n][0]].type;
          for (int i = 0; i < adj[n].size(); i++) {
               node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
          }       
          string temp1 = get_new_temp();
          string temp2 = get_new_temp();
          string temp3 = get_new_temp();
          string temp4 = get_new_temp();
          string temp5 = get_new_temp();
          int sym_ind = -1;
          int var_size = 0;
          switch(reducer){
               case 0:
                    sym_ind = var_sym(node_to_sym_tab[parse_to_ast[n]], node_attr_map[adj[n][0]].variable, parse_to_ast[n]);

                    node_attr_map[n].code += temp1 + " = " + node_attr_map[adj[n][0]].offset + "*" + sym_tab[sym_ind][node_attr_map[adj[n][0]].variable]["dim" + to_string(node_attr_map[adj[n][0]].dim_count)] + "\n";

                    node_attr_map[n].code += temp2 + " = " + temp1 + "+" + node_attr_map[adj[n][2]].variable + "\n";
                    // +"symtable(" + node_attr_map[adj[n][0]].variable+".dim" + to_string(node_attr_map[adj[n][0]].dim_count)+

                    var_size = get_type_size(sym_tab[sym_ind][node_attr_map[adj[n][0]].variable]["Type"]);
                    node_attr_map[n].code += temp3 + " = " + temp2 + "*" + to_string(var_size) + "\n";

                    node_attr_map[n].code += temp4 + " = " + temp3 + "+" + node_attr_map[adj[n][0]].variable + "\n";

                    node_attr_map[n].arr_ptr = node_attr_map[adj[n][0]].variable;
                    node_attr_map[n].dim_count += 1;
                    node_attr_map[n].offset = temp2;
                    node_attr_map[n].variable ="*" + temp4;
                    break;
               case 1:
                    sym_ind = var_sym(node_to_sym_tab[parse_to_ast[n]], node_attr_map[adj[n][0]].arr_ptr, parse_to_ast[n]);
                    node_attr_map[n].arr_ptr = node_attr_map[adj[n][0]].arr_ptr;

                    node_attr_map[n].code += temp1 + " = " + node_attr_map[adj[n][0]].offset + "*" + sym_tab[sym_ind][node_attr_map[n].arr_ptr]["dim" + to_string(node_attr_map[adj[n][0]].dim_count)] + "\n";
                    // +"symtable(" + node_attr_map[adj[n][0]].arr_ptr+".dim" + to_string(node_attr_map[adj[n][0]].dim_count)+
                    node_attr_map[n].code += temp2 + " = " + temp1 + "+" + node_attr_map[adj[n][2]].variable + "\n";

                    var_size = get_type_size(sym_tab[sym_ind][node_attr_map[n].arr_ptr]["Type"]);
                    node_attr_map[n].code += temp3 + " = " + temp2 + "*" + to_string(var_size) + "\n";

                    node_attr_map[n].code += temp4 + " = " + temp3 + "+" + node_attr_map[adj[n][0]].arr_ptr + "\n";
                    // node_attr_map[n].arr_ptr = node_attr_map[adj[n][0]].variable;
                    node_attr_map[n].dim_count += 1;
                    node_attr_map[n].offset = temp2;
                    node_attr_map[n].variable ="*" + temp4;
                    break;
          } 
          return;
     }

     if (name == "PostfixExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you in postfix\n";
          return;
     }
     if (name == "PostIncrementExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          node_attr_map[n].variable = get_new_temp();
          if (node_attr_map[n].type == "int"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +int 1\n";
          }
          else if (node_attr_map[n].type == "float"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +float 1.0\n";
          }
          node_attr_map[n].code += node_attr_map[adj[n][0]].variable + " = " + node_attr_map[n].variable + "\n";
          // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "PostDecrementExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          node_attr_map[n].variable = get_new_temp();
          if (node_attr_map[n].type == "int"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -int 1\n";
          }
          else if (node_attr_map[n].type == "float"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -float 1.0\n";
          }         
          node_attr_map[n].code += node_attr_map[adj[n][0]].variable  + " = " + node_attr_map[n].variable + "\n";
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "UnaryExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][1]];
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][1]];
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = -" + node_attr_map[adj[n][1]].variable + "\n";
                    break;
               case 4:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
          }
          
          // if(node_attr_map[n].label ==  "L3")
          // cout << node_attr_map[n].code;
          // cout << "found you in unary\n";
          return;
     }
     if (name == "PreIncrementExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          node_attr_map[n].variable = get_new_temp();
          if (node_attr_map[n].type == "int"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +int 1\n";
          }
          else if (node_attr_map[n].type == "float"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +float 1.0\n";
          }
          node_attr_map[n].code += node_attr_map[adj[n][0]].variable + " = " + node_attr_map[n].variable + "\n";
          // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "PreDecrementExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          node_attr_map[n].variable = get_new_temp();
          if (node_attr_map[n].type == "int"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -int 1\n";
          }
          else if (node_attr_map[n].type == "float"){
               node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -float 1.0\n";
          }         
          node_attr_map[n].code += node_attr_map[adj[n][0]].variable  + " = " + node_attr_map[n].variable + "\n";
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "UnaryExpressionNotPlusMinus"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][1]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = -" + node_attr_map[adj[n][0]].variable + "\n";
                    break;
               case 2:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][1]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = !" + node_attr_map[adj[n][1]].variable + "\n";
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code += node_attr_map[n].variable + " = 0 -" + node_attr_map[adj[n][1]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "CastExpression"){
          // unimplemented
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "MultiplicativeExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    if (node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type)
                         node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " *" + node_attr_map[adj[n][0]].type + " " +node_attr_map[adj[n][2]].variable + "\n";
                    else {
                         if (node_attr_map[adj[n][0]].type == "int"){
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 +  " = cast to float " + node_attr_map[adj[n][0]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + temp1 + " *float " + node_attr_map[adj[n][2]].variable + "\n";
                         }
                         else{
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " *float " + temp1 + "\n";
                         }
                         node_attr_map[n].type = "float";
                    }
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    if (node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type)
                         node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " /"+node_attr_map[adj[n][0]].type + " "  + node_attr_map[adj[n][2]].variable + "\n";
                    else {
                         if (node_attr_map[adj[n][0]].type == "int"){
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][0]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + temp1 + " /float " + node_attr_map[adj[n][2]].variable + "\n";
                         }
                         else{
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " /float " + temp1 + "\n";
                         }
                         node_attr_map[n].type = "float";
                    }
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    if (node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type)
                         node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " %" +node_attr_map[adj[n][0]].type + " "+  node_attr_map[adj[n][2]].variable + "\n";
                    else {
                         if (node_attr_map[adj[n][0]].type == "int"){
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][0]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + temp1 + " %float " + node_attr_map[adj[n][2]].variable + "\n";
                         }
                         else{
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " %float " + temp1 + "\n";
                         }
                         node_attr_map[n].type = "float";
                    }
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }


     if (name == "AdditiveExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    if ((node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type) ||(node_attr_map[adj[n][0]].type == "int" && node_attr_map[adj[n][2]].type == "float") || (node_attr_map[adj[n][0]].type == "") ||( node_attr_map[adj[n][2]].type == ""))
                         node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +" + node_attr_map[adj[n][0]].type + " " + node_attr_map[adj[n][2]].variable + "\n";
                    else {
                         if (node_attr_map[adj[n][0]].type == "int"){
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][0]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + temp1 + " +float " + node_attr_map[adj[n][2]].variable + "\n";
                         }
                         else{
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " +float " + temp1 + "\n";
                         }
                         node_attr_map[n].type = "float";
                    }
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    if (node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type)
                         node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -"+node_attr_map[adj[n][0]].type + " "  + node_attr_map[adj[n][2]].variable + "\n";
                    else {
                         if (node_attr_map[adj[n][0]].type == "int"){
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 + " = cast to float " + node_attr_map[adj[n][0]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + temp1 + " -float " + node_attr_map[adj[n][2]].variable + "\n";
                         }
                         else{
                              string temp1  = get_new_temp();
                              node_attr_map[n].code += temp1 +" = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
                              node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " -float " + temp1 + "\n";
                         }
                         node_attr_map[n].type = "float";
                    }
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ShiftExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " << " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " >> " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " >>> " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "RelationalExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " < " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 2:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " > " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 3:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " <= " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 4:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " >= " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 5: 
                    // instanceof unimplemented
                    break;
          }
          node_attr_map[n].type = "boolean";
          node_attr_map[n].size = 1;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "EqualityExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " == " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
               case 2:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " != " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          node_attr_map[n].type = "boolean";
          node_attr_map[n].size = 1;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "AndExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          switch(reducer){
               case 0:
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " & " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ExclusiveOrExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          switch(reducer){
               case 0:
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " ^ " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "InclusiveOrExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          switch(reducer){
               case 0:
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " | " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ConditionalAndExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          switch(reducer){
               case 0:
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " && " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ConditionalOrExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          switch(reducer){
               case 0:
                    break;
               case 1:
                    node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                    node_attr_map[n].variable = get_new_temp();
                    node_attr_map[n].code += node_attr_map[n].variable + " = " + node_attr_map[adj[n][0]].variable + " || " + node_attr_map[adj[n][2]].variable + "\n";
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
     if (name == "ConditionalExpression"){
          switch(reducer){
               case 0:
                    node_attr_map[n] = node_attr_map[adj[n][0]];
                    break;
               case 1:
                    string code;

                    string true_label = get_new_label();
                    string false_label = get_new_label();
                    node_attr_map[n].label = get_new_label();

                    code += "if " + node_attr_map[adj[n][0]].variable + " goto " + true_label + "\n";
                    code += "goto " + false_label + "\n";
                    code += true_label + " : " + node_attr_map[adj[n][2]].code;
                    code += "goto " + node_attr_map[n].label;
                    code += false_label + " : " + node_attr_map[adj[n][4]].code;
                    code += "goto " + node_attr_map[n].label;
                    code += node_attr_map[n].label + " : ";

                    node_attr_map[n].code = code;
                    node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
                    break;
          }
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "AssignmentExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "Assignment"){
          node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code ; 
          if ((node_attr_map[adj[n][0]].type == node_attr_map[adj[n][2]].type) || (node_attr_map[adj[n][0]].type == "") || (node_attr_map[adj[n][2]].type == ""))
               node_attr_map[n].code += node_attr_map[adj[n][0]].variable + " = " + node_attr_map[adj[n][2]].variable + "\n";
          else{
               string temp = get_new_temp();
               node_attr_map[n].code += temp + " = cast to float " + node_attr_map[adj[n][2]].variable + "\n";
               node_attr_map[n].code += node_attr_map[adj[n][0]].variable + " = " + node_attr_map[adj[n][2]].variable + "\n";
          }
          node_attr_map[n].type = node_attr_map[adj[n][0]].type;
          node_attr_map[adj[n][0]].variable + " = " + node_attr_map[adj[n][2]].variable + "\n";
          node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "LeftHandSide"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "AssignmentOperator"){
          node_attr_map[n].variable = nodes[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "Expression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }

     if (name == "ConstantExpression"){
          node_attr_map[n] = node_attr_map[adj[n][0]];
          // cout << node_attr_map[n].code;
          // if(node_attr_map[n].label ==  "L3")
          // cout << "found you\n";
          return;
     }
}

void postorder(int nodes) {
    for (int i = 0; i < adj[nodes].size(); i++) {
        postorder(adj[nodes][i]);
    }
    postorder_3AC(nodes);
}

void generate_3AC(string s, string file){
     map<string,int> m;
     ofstream myfile;
     myfile.open(file);
     // myfile << s;
     // myfile << "END : " << endl;
     int line_count = 1;

     for(auto it = s.begin(); it != s.end();){
          if(*it == '\n'){
               while(it!=s.end() && *it == '\n'){
                    it++;
                    if(*it == '\n')
                         it = s.erase(it);
               }
               line_count++;
               // cout << line_count << endl;
          }
          else if(*it == 'L'){
               while(it != s.end() && *it == 'L'){
                    string label = "";
                    while(it != s.end() && *it != ' '){
                         label += *it;
                         it++;
                    }
                    // cout << label << " " << line_count << endl;
                    m[label] = line_count;
                    it += 3;
                    if(it != s.end() && *it == '\n')
                         line_count--;
               }
          }
          else{
               while(it != s.end() && *it != '\n')
                    it++;
          }

     }

     for(auto it = m.begin(); it != m.end(); it++){
          while(s.find(it->first + " : ") != string::npos){
               // myfile << "found ya" << it->first << endl;
               s.erase(s.find(it->first + " : "), it->first.length() + 3);
          }
     }

     for(auto it = m.rbegin(); it != m.rend(); it++)
          while(s.find(it->first) != string::npos)
               s.replace(s.find(it->first), (it->first).length(), to_string(it->second));

     // myfile << "map begins" << endl;
     // for(auto it = m.begin(); it != m.end(); it++)
     //      myfile << it->first << " : " << it->second << endl;
     myfile << s;
}
     