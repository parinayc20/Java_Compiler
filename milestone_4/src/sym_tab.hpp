#include<bits/stdc++.h>
using namespace std;

#ifndef SYM_TAB
#define SYM_TAB

extern vector<string> nodes;
extern vector<int> line_no;
extern vector<vector<int>> adj;
extern int node_count;

extern vector<string> nodes_copy;
extern vector<vector<int>> adj_copy;

extern map<int, int> node_prod;

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

pair<string, int> type_recur(int src) {
     string res="";
     int array_dims = 0;
     bool is_upper = true;
     for(auto letter: nodes_copy[src]) {
          if(letter == '_')
               continue;
          int diff = letter - 'A';
          if(diff < 0 || diff >= 26) {
               is_upper = false;
               break;
          }
     }
     if(is_upper) {
          if(nodes_copy[src] == "SQUARE_OPEN")
               array_dims ++;
          else if (nodes_copy[src] == "SQUARE_CLOSE")
               return {"", 0};
          else
               res = nodes_copy[adj_copy[src][0]];
          return {res, array_dims};
     }
     for(auto child: adj_copy[src]) {
          pair<string, int> ret = type_recur(child);
          res = res + ret.first;
          array_dims += ret.second;
     }
     return {res, array_dims};
}

vector<pair<string, int>> vars_recur(int src, pair<string, int> type) {
     if(nodes_copy[src] == "VariableDeclaratorId")
          node_to_type[src] = type;
     vector<pair<string, int>> res;
     string iden_val="";
     int array_dims = 0;
     bool is_upper = true;
     for(auto letter: nodes_copy[src]) {
          if(letter == '_')
               continue;
          int diff = letter - 'A';
          if(diff < 0 || diff >= 26) {
               is_upper = false;
               break;
          }
     }
     if(is_upper) {
          if(nodes_copy[src] == "SQUARE_OPEN")
               array_dims ++;
          else if (nodes_copy[src] == "SQUARE_CLOSE")
          {}
          else if (nodes_copy[src] == "COMMA") 
          {}
          else
          {
               iden_val = nodes_copy[adj_copy[src][0]];
          }
          res.push_back({iden_val, array_dims});
          return res;
     }

     bool flag = false;
     for(auto child: adj_copy[src]) {
          if(nodes_copy[child] == "ASSIGN" || nodes_copy[child] == "ASSIGN(=)") {
               break;
          }
          else if(nodes_copy[child] == "COMMA") {
               continue;
          }
          else if(nodes_copy[child] == "VariableDeclarators") {
               res = vars_recur(child, type);
          }
          else if(nodes_copy[child] == "VariableDeclarator") {
               vector<pair<string, int>> ret = vars_recur(child, type);
               res.push_back(ret[0]);
          }
          else {
               vector<pair<string,int>> ret = vars_recur(child, type);
               for(auto ret_val: ret) {
                    iden_val = iden_val + ret_val.first;
                    array_dims += ret_val.second;
               }
               flag = true;
          }
     }
     if(nodes_copy[src] == "VariableDeclaratorId")
          node_to_type[src].second += array_dims;
     if(flag) {
          res.push_back({iden_val, array_dims});
     }
     return res;
}

vector<pair<string, map<string, string>>> params_recur(int src) {
     vector<pair<string, map<string, string>>> res;
     for(auto child: adj_copy[src]) {
          if(nodes_copy[child] == "COMMA")
               continue;
          else if(nodes_copy[child] == "FormalParameterList") {
               res = params_recur(child);
          }
          else if(nodes_copy[child] == "FormalParameter") {
               map<string, string> param_attrs;
               for(auto ch_ : adj_copy[child]) {
                    if(nodes_copy[ch_] == "VariableModifier") {
                         param_attrs["Modifier_1"] = "final";
                    }
                    else if(nodes_copy[ch_] == "Type") {
                         pair<string, int> type_ret = type_recur(ch_);
                         param_attrs["Type"] = type_ret.first;
                         param_attrs["Array_dims"] = to_string(type_ret.second);
                    }
                    else if(nodes_copy[ch_] == "VariableDeclaratorId") {
                         vector<pair<string, int>> var_ret = vars_recur(ch_, {param_attrs["Type"], stoi(param_attrs["Array_dims"])});
                         pair<string, int> var = var_ret[0];
                         param_attrs["Array_dims"] = to_string(stoi(param_attrs["Array_dims"]) + var.second);
                         res.push_back({var.first, param_attrs});
                    }
               }
          }
     }
     return res;
}

bool check_var(int sym_tab_ind, string name) {
     // cerr << "Inside check var" << endl;
     if(sym_tab_ind == 0)
          return false;
     if(sym_tab[sym_tab_ind].find(name) != sym_tab[sym_tab_ind].end()) {
          if(sym_tab[sym_tab_ind][name].find("is_global") != sym_tab[sym_tab_ind][name].end()) {
               return false;
          }
          return true;
     }
     return check_var(parent[sym_tab_ind], name);
}

void print_sym_tab(int st) {
     if(sym_tab[st].size() > 0) {
          string output_file = "symbol_table_" + to_string(st) + ".csv";
          ofstream dotFile(output_file.c_str());
          for(auto x: sym_tab[st]) {
               dotFile << x.first << endl;
               for(auto y: x.second) {
                    dotFile << y.first << "," << y.second << endl;
               }
               dotFile << endl;
          }
     }
     for (auto child: children[st]) {
          print_sym_tab(child);
     }
}

vector<string> pt_travel(int src, int curr_ind, string class_name, string func_name) {
     // cerr << "Inside" << endl;
     // cerr << nodes_copy[src] << endl;
     // cerr << src << endl;
     node_to_sym_tab[src] = curr_ind;
     vector<string> no_ret;
     if(nodes_copy[src] == "Modifiers") {
          vector<string> st;
          for(auto child: adj_copy[src]) {
               if(nodes_copy[child] == "Modifier") {
                    st.push_back(nodes_copy[adj_copy[adj_copy[child][0]][0]]);
               }
               else if(nodes_copy[child] == "Modifiers") {
                    vector<string> new_st = pt_travel(child, curr_ind, class_name, func_name);
                    for(auto mod: new_st)
                         st.push_back(mod);
               }
          }
          return st;
     }
     else if(nodes_copy[src] == "ClassDeclaration") {
          curr_sym_tab++;
          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          map<string, string> class_attrs;
          for(auto child: adj_copy[src]) {
               if(nodes_copy[child] == "Modifiers") {
                    vector<string> mods = pt_travel(child,curr_ind, class_name, func_name);
                    for(int i=0; i<mods.size(); i++) {
                         class_attrs["Modifier_" + to_string(i+1)] = mods[i];
                    }
               }
               else if(nodes_copy[child] == "IDENTIFIER") {
                    class_name = nodes_copy[adj_copy[child][0]];
                    class_map[class_name] = curr_sym_tab;
                    if(sym_tab[curr_ind].find(class_name) !=  sym_tab[curr_ind].end()) {
                         fprintf(stderr, "Line number:%d Error: Duplicate class %s\n", line_no[src], class_name.c_str());
                         exit(0);
                    }
                    class_attrs["is_class"] = "true";
                    class_attrs["line_no"] = to_string(line_no[src]) ;
                    sym_tab[curr_ind][class_name] = class_attrs;
               }
               else if(nodes_copy[child] == "CLASS") {
                    continue;
               }
               else {
                    curr_ind = inserted_tab_ind;
                    vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
               }
          }
          return no_ret;
     }
     else if(nodes_copy[src] == "FieldDeclaration") {
          map<string, string> vars_attrs;       
          for(auto child: adj_copy[src]) {
               if(nodes_copy[child] == "Modifiers") {
                    vector<string> mods = pt_travel(child, curr_ind, class_name, func_name);
                    for(int i=0; i<mods.size(); i++) {
                         vars_attrs["Modifier_" + to_string(i+1)] = mods[i];
                    }
               }
               else if(nodes_copy[child] == "Type") {
                    pair<string, int> res = type_recur(child);
                    vars_attrs["Type"] = res.first;
                    vars_attrs["Array_dims"] = to_string(res.second);
               }
               else if(nodes_copy[child] == "VariableDeclarators") {
                    vector<pair<string, int>> ret = vars_recur(child, {vars_attrs["Type"], stoi(vars_attrs["Array_dims"])});
                    for(auto var: ret) {
                         if(sym_tab[curr_ind].find(var.first) !=  sym_tab[curr_ind].end()) {
                              fprintf(stderr, "Line number:%d Error: Duplicate global variable %s\n", line_no[src], (var.first).c_str());
                              exit(0);
                         }
                         map<string, string> var_attrs = vars_attrs;
                         var_attrs["Array_dims"] = to_string(stoi(var_attrs["Array_dims"]) + var.second);
                         var_attrs["is_global"] = "true";
                         var_attrs["line_no"] = to_string(line_no[src]) ;
                         var_attrs["class_name"] = class_name;
                         sym_tab[curr_ind][var.first] = var_attrs;
                    }
                    
               }
          }
          return no_ret;
     }
     else if(nodes_copy[src] == "MethodDeclaration") {
          curr_sym_tab ++;
          func_param_ind ++;
          vector<pair<string, map<string, string>>> new_func;
          func_params.push_back(new_func);

          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          for(auto child : adj_copy[src]) {
               if(nodes_copy[child] == "MethodHeader") {
                    curr_ind = inserted_tab_ind;
                    vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
                    func_name = res[0];
               }
               else {
                    curr_ind = inserted_tab_ind;
                    vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
               }
          }
          return no_ret;
     }
     else if(nodes_copy[src] == "MethodHeader") {
          map<string, string> func_attrs;
          for(auto child: adj_copy[src]) {
               if(nodes_copy[child] == "Modifiers") {
                    vector<string> mods = pt_travel(child, curr_ind, class_name, func_name);
                    for(int i=0; i<mods.size(); i++) {
                         func_attrs["Modifier_" + to_string(i+1)] = mods[i];
                    }
               }
               else if(nodes_copy[child] == "Type") {
                    pair<string, int> res = type_recur(child);
                    func_attrs["Type"] = res.first;
                    func_attrs["Array_dims"] = to_string(res.second);
               }
               else if(nodes_copy[child] == "VOID") {
                    func_attrs["Type"] = "None";
                    func_attrs["Array_dims"] = "0";
               }
               else if(nodes_copy[child] == "MethodDeclarator") {
                    if(nodes_copy[adj_copy[child][0]] == "IDENTIFIER") {
                         func_name = nodes_copy[adj_copy[adj_copy[child][0]][0]];
                    }
                    if(func_name == class_name) {
                         fprintf(stderr, "Line number:%d Error: Function name same as class name\n", line_no[child]);
                         exit(0);
                    }
                    if(sym_tab[parent[curr_ind]].find(func_name) !=  sym_tab[parent[curr_ind]].end()) {
                         fprintf(stderr, "Line number:%d Error: Duplicate method name\n", line_no[child]);
                         exit(0);
                    }
                    func_attrs["is_func"] = "true";
                    func_attrs["func_param_index"] = to_string(func_param_ind);
                    func_attrs["is_global"] = "true";
                    func_attrs["line_no"] = to_string(line_no[src]) ;
                    func_attrs["class_name"] = class_name;
                    func_attrs["sym_tab_ind"] = to_string(curr_ind);
                    sym_tab[parent[curr_ind]][func_name] = func_attrs;

                    for(int i = 1; i < adj_copy[child].size(); i++) {
                         vector<string> res = pt_travel(adj_copy[child][i], curr_ind, class_name, func_name);
                    }
               }
               else {
                    vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
               }
          }
          vector<string> f_name;
          f_name.push_back(func_name);
          return f_name;
     }
     else if(nodes_copy[src] == "FormalParameterList") {
          vector<pair<string, map<string, string>>> params_ret = params_recur(src);
          func_params[func_param_ind] = params_ret;
          for(auto param: params_ret) {
               if(sym_tab[curr_ind].find(param.first) !=  sym_tab[curr_ind].end()) {
                    fprintf(stderr, "Line number:%d Error: Duplicate parameters\n", line_no[src]);
                    exit(0);
               }
               param.second["line_no"] = to_string(line_no[src]) ;
               param.second["class_name"] = class_name;
               param.second["func_name"] = func_name;
               sym_tab[curr_ind][param.first] = param.second;
          }
          return no_ret;
     }
     else if(nodes_copy[src] == "LocalVariableDeclaration") {
          map<string, string> vars_attrs;       
          for(auto child: adj_copy[src]) {
               // cerr << nodes_copy[child] << endl;
               if(nodes_copy[child] == "VariableModifiers") {
                    vars_attrs["Modifier_1"] = "final";
               }
               else if(nodes_copy[child] == "Type") {
                    pair<string, int> res = type_recur(child);
                    vars_attrs["Type"] = res.first;
                    vars_attrs["Array_dims"] = to_string(res.second);
               }
               else if(nodes_copy[child] == "VariableDeclarators") {
                    vector<pair<string, int>> ret = vars_recur(child, {vars_attrs["Type"], stoi(vars_attrs["Array_dims"])});
                    for(auto var: ret) {
                         if(check_var(curr_ind, var.first)) {
                              fprintf(stderr, "Line number:%d Error: Duplicate Local Variable %s\n", line_no[child], (var.first).c_str());
                              exit(0);
                         }
                         map<string, string> var_attrs = vars_attrs;
                         var_attrs["Array_dims"] = to_string(stoi(var_attrs["Array_dims"]) + var.second);
                         var_attrs["line_no"] = to_string(line_no[src]) ;
                         var_attrs["class_name"] = class_name;
                         var_attrs["func_name"] = func_name;
                         sym_tab[curr_ind][var.first] = var_attrs;
                    }
                    
               }
          }
          return no_ret;
     }
     else if(nodes_copy[src] == "ConstructorDeclaration") {
          curr_sym_tab ++;
          func_param_ind ++;
          vector<pair<string, map<string, string>>> new_func;
          func_params.push_back(new_func);

          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          map<string, string> func_attrs;
          for(auto child: adj_copy[src]) {
               if(nodes_copy[child] == "Modifiers") {
                    vector<string> mods = pt_travel(child, curr_ind, class_name, func_name);
                    for(int i=0; i<mods.size(); i++) {
                         func_attrs["Modifier_" + to_string(i+1)] = mods[i];
                    }
               }
               else if(nodes_copy[child] == "ConstructorDeclarator") {
                    pair<string, int> const_name = type_recur(adj_copy[child][0]);
                    if(const_name.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Wrong constructor initialization\n", line_no[child]);
                         exit(0);
                    }
                    if(const_name.first != class_name) {
                         fprintf(stderr, "Line number:%d Error: Constructor name not same as class name\n", line_no[child]);
                         exit(0);
                    }
                    func_attrs["is_func"] = "true";
                    func_attrs["Type"] = "None";
                    func_attrs["Array_dims"] = "0";
                    func_attrs["func_param_index"] = to_string(func_param_ind);
                    func_attrs["line_no"] = to_string(line_no[src]) ;
                    func_attrs["class_name"] = class_name;
                    func_attrs["sym_tab_ind"] = to_string(inserted_tab_ind);
                    func_name = const_name.first;
                    sym_tab[curr_ind][const_name.first] = func_attrs;
                    vector<string> res = pt_travel(child, inserted_tab_ind, class_name, func_name);
               }
               else {
                    curr_ind = inserted_tab_ind;
                    vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
               }
          }
          return no_ret;
     }
     else if(nodes_copy[src] == "ForStatement" || nodes_copy[src] == "ForStatementNoShortIf") {
          curr_sym_tab ++;
          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          for(auto child: adj_copy[src]) {
               curr_ind = inserted_tab_ind;
               vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
          }
          return no_ret;
     }
     else if(nodes_copy[src] == "SwitchBlock") {
          curr_sym_tab ++;
          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          for(auto child: adj_copy[src]) {
               curr_ind = inserted_tab_ind;
               vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
          }
          return no_ret;
     }
     else if(nodes_copy[src] == "Block") {
          curr_sym_tab ++;
          int inserted_tab_ind = curr_sym_tab;
          map<string, map<string, string>> nmap;
          sym_tab.push_back(nmap);

          parent[curr_sym_tab] = curr_ind;
          if(children.find(curr_ind) == children.end()) 
          {    vector<int> vec_ch;
               children[curr_ind] = vec_ch;
          }
          children[curr_ind].push_back(curr_sym_tab);

          for(auto child: adj_copy[src]) {
               curr_ind = inserted_tab_ind;
               vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
          }
          return no_ret;
     }
     else {
          for(auto child : adj_copy[src]) {
               vector<string> res = pt_travel(child, curr_ind, class_name, func_name);
          }
          return no_ret;
     }
}

pair<string, int> var_scope_check(int sym_tab_ind, string name, int src){
     if(sym_tab_ind == 0)
     return {"", -1};
     if(sym_tab[sym_tab_ind].find(name) != sym_tab[sym_tab_ind].end()) {
          if(sym_tab[sym_tab_ind][name].find("is_func") == sym_tab[sym_tab_ind][name].end()) {
               if(sym_tab[sym_tab_ind][name].find("is_global") == sym_tab[sym_tab_ind][name].end()) {
                    return {sym_tab[sym_tab_ind][name]["Type"], stoi(sym_tab[sym_tab_ind][name]["Array_dims"])};
               }
               if(stoi(sym_tab[sym_tab_ind][name]["line_no"]) <= line_no[src]) {
                    return {sym_tab[sym_tab_ind][name]["Type"], stoi(sym_tab[sym_tab_ind][name]["Array_dims"])};
               }
          }
     }
     return var_scope_check(parent[sym_tab_ind], name, src);
}

int var_sym(int sym_tab_ind, string name, int src) {
     if(sym_tab_ind == 0)
     return 0;
     if(sym_tab[sym_tab_ind].find(name) != sym_tab[sym_tab_ind].end()) {
          if(sym_tab[sym_tab_ind][name].find("is_func") == sym_tab[sym_tab_ind][name].end()) {
               if(sym_tab[sym_tab_ind][name].find("is_global") == sym_tab[sym_tab_ind][name].end()) {
                    return sym_tab_ind;
               }
               if(stoi(sym_tab[sym_tab_ind][name]["line_no"]) <= line_no[src]) {
                    return sym_tab_ind;
               }
          }
     }
     return var_sym(parent[sym_tab_ind], name, src);
}

string find_class(int sym_tab_ind) {
     if(class_map_2.find(sym_tab_ind) != class_map_2.end())
          return class_map_2[sym_tab_ind];
     return find_class(parent[sym_tab_ind]);
}

pair<string, int> find_func(int curr_tab_ind, int child_tab_ind) {
     if(curr_tab_ind == 0)
          return {"", -1};
     for(auto elems: sym_tab[curr_tab_ind]) {
          if(elems.second.find("is_func") != elems.second.end()) {
               if(stoi(elems.second["sym_tab_ind"]) == child_tab_ind)
                    return {elems.first, curr_tab_ind};
          }
     }
     return find_func(parent[curr_tab_ind], curr_tab_ind);
}

string var_data_type(string type) {
     if(type == "long" || type == "int" || type == "short" || type == "char" || type == "byte" || type == "lit")
          return "integer";
     else if(type == "float" || type == "double")
          return "decimal";
     else if(type == "boolean")
          return "boolean";
     else if(type == "String")
          return "String"; 
     else if(type == "null")
          return "null";
     else 
          return "object";
}

int get_type_size(string type) {
     if(type == "long")
          return 8;
     if(type == "int")
          return 4;
     if(type == "short")
          return 2;
     if(type == "char")
          return 2;
     if(type == "byte")
          return 1;
     if(type == "float")
          return 4;
     if(type == "double")
          return 8;
     if(type == "boolean")
          return 1;
     if(type == "String")
          return 8;
     return 8;
}

bool type_match(string type1, string type2) {
     if(type1 == "String" && type2 == "null")
          return true;
     if(type1 == "object" && type2 == "null")
          return true;
     if(type1 == "String" || type1 == "boolean" || type2 == "String" || type2 == "boolean")
     {
          if(var_data_type(type1) != var_data_type(type2))
               return false;
          return true;
     }

     if(var_data_type(type1) == "object" || var_data_type(type2) == "object"){
          return type1 == type2;
     }

     int num_type1 = 0, num_type2 = 0;
     if(var_data_type(type1) == "integer") {
          if(type1 == "long")
               num_type1 = 5;
          else if(type1 == "int")
               num_type1 = 4;
          else if(type1 == "short")
               num_type1 = 3;
          else if(type1 == "char")
               num_type1 = 2;
          else if(type1 == "byte")
               num_type1 = 1;

          if(type2 == "long")
               num_type2 = 5;
          else if(type2 == "int")
               num_type2 = 4;
          else if(type2 == "short")
               num_type2 = 3;
          else if(type2 == "char")
               num_type2 = 2;
          else if(type2 == "byte")
               num_type2 = 1;
     }
     else {
          if(type1 == "double")
               num_type1 = 7;
          else
               num_type1 = 6;

          if(type2 == "double")
               num_type2 = 7;
          else 
               num_type2 = 6;
     }

     if(type1 == "char" && (type2 == "short" || type2 == "byte")) 
          return false;
     if(type2 == "char" && (type1 == "short" || type1 == "byte"))
          return false;

     if(num_type1 >= num_type2)
          return true;
     else 
          return false;
}

int arithmetic_return(string type) {
     if(type == "String")
          return 8;
     if(type == "double")
          return 7;
     if(type == "float") 
          return 6;
     if(type == "long")
          return 5;
     if(type == "int")
          return 4;
     if(type == "short")
          return 3;
     if(type == "char")
          return 2;
     if(type == "byte")
          return 1;
     return 0;
}

string get_type(int src) {
     string iden_val = "";
     bool is_upper = true;
     for(auto letter: nodes_copy[src]) {
          if(letter == '_')
               continue;
          int diff = letter - 'A';
          if(diff < 0 || diff >= 26) {
               is_upper = false;
               break;
          }
     }
     if(is_upper) {
          return nodes_copy[adj_copy[src][0]];
     }
     for(auto child: adj_copy[src]) {
          iden_val += get_type(child);
     }
     return iden_val;
}

int get_dims(int src) {
     int dims = 0;
     if(nodes_copy[src] == "SQUARE_OPEN")
          return 1;
     for(auto child: adj_copy[src]) {
          dims += get_dims(child);
     }
     return dims;
}

string scope_check(int src, int type) {
     // cerr << nodes_copy[src] << endl;
     if(nodes_copy[src] == "PackageDeclaration")
          return "";
     if(nodes_copy[src] == "ImportDeclarations")
          return "";
     if(nodes_copy[src] == "IDENTIFIER") {
          return nodes_copy[adj_copy[src][0]];
     }
     else if(nodes_copy[src] == "DOT") {
          return ".";
     }
     else if(nodes_copy[src] == "THIS") {
          return "this";
     }
     else if(nodes_copy[src] == "Name") {
          string name = "";
          int ntype = type;
          if(type == 0)
               ntype = 1;
          for(auto child : adj_copy[src]) {
               name += scope_check(child, ntype);
          }
          if(ntype > type){
               vector<string> vars;
               string curr_name = "";
               for(auto letter : name) {
                    if(letter == '.') {
                         vars.push_back(curr_name);
                         curr_name = "";
                         continue;
                    }
                    curr_name += letter;
               }
               vars.push_back(curr_name);
               if(vars.size() > 2) {
                    cerr << "Constraints dissatisfied. Chain of accesses present : " << name << "\n";
                    exit(0); 
               }
               if(vars.size() == 1) {
                    pair<string, int> type = var_scope_check(node_to_sym_tab[src], vars[0], src);
                    if(type.second == -1) {
                         if(class_map.find(vars[0]) == class_map.end()){
                              fprintf(stderr, "Line number:%d Error: Variable %s out of scope\n", line_no[src], (vars[0]).c_str());
                              exit(0);
                         }
                         node_to_type[src] = {vars[0], 0};
                    }
                    else {
                         node_to_type[src] = type;
                    }
               }
               else {
                    pair<string, int> type = var_scope_check(node_to_sym_tab[src], vars[0], src);
                    string ref_type = type.first;
                    if(type.first == "")
                         ref_type = vars[0];
                    if(class_map.find(ref_type) == class_map.end()){
                         fprintf(stderr, "Line number:%d Error: Variable %s out of scope\n", line_no[src], (vars[0]).c_str());
                         exit(0);
                    }
                    int class_ind = class_map[ref_type];
                    vars[0] = ref_type;
                    if(sym_tab[class_ind].find(vars[1]) == sym_tab[class_ind].end()) {
                         fprintf(stderr, "Line number:%d Error: No member %s of class %s found\n", line_no[src], (vars[1]).c_str(), (vars[0]).c_str());
                         exit(0);
                    }
                    if(sym_tab[class_ind][vars[1]].find("is_func") != sym_tab[class_ind][vars[1]].end()) {
                         fprintf(stderr, "Line number:%d Error: No member %s of class %s found\n", line_no[src], (vars[1]).c_str(), (vars[0]).c_str());
                         exit(0);
                    }
                    string this_class = find_class(node_to_sym_tab[src]);
                    if(this_class != ref_type) {
                         bool is_private = false;
                         for(auto elem: sym_tab[class_ind][vars[1]]) {
                              if(elem.second == "private"){
                                   is_private = true;
                                   break;
                              }
                         }
                         if(is_private) {
                              fprintf(stderr, "Line number:%d Error: Member %s of class %s is private\n", line_no[src], (vars[1]).c_str(), (vars[0]).c_str());
                              exit(0);
                         }
                    }
                    node_to_type[src] = {sym_tab[class_ind][vars[1]]["Type"], stoi(sym_tab[class_ind][vars[1]]["Array_dims"])};
               }
               return "";
          }
          return name;
     }
     else if(nodes_copy[src] == "FieldAccess") {
          string name = "";
          int ntype = type;
          if(type < 2)
               ntype = 2;
          for(auto child : adj_copy[src]) {
               name += scope_check(child, ntype);
          }
          if(ntype > type){
               vector<string> vars;
               string curr_name = "";
               for(auto letter : name) {
                    if(letter == '.') {
                         vars.push_back(curr_name);
                         curr_name = "";
                         continue;
                    }
                    curr_name += letter;
               }
               vars.push_back(curr_name);
               if(vars.size() == 2) {
                    if(vars[0] == "this") {
                         string class_name = find_class(node_to_sym_tab[src]);
                         int class_ind = class_map[class_name];
                         if(sym_tab[class_ind].find(vars[1]) == sym_tab[class_ind].end()) {
                              fprintf(stderr, "Line number:%d Error: No member %s of class %s found\n", line_no[src], (vars[1]).c_str(), (class_name).c_str());
                              exit(0);
                         }
                         if(sym_tab[class_ind][vars[1]].find("is_func") != sym_tab[class_ind][vars[1]].end()) {
                              fprintf(stderr, "Line number:%d Error: No member %s of class %s found\n", line_no[src], (vars[1]).c_str(), (class_name).c_str());
                              exit(0);
                         }
                         node_to_type[src] = {sym_tab[class_ind][vars[1]]["Type"], stoi(sym_tab[class_ind][vars[1]]["Array_dims"])};
                    }
               }
               return "";
          }
          return name;
     }
     else if(nodes_copy[src] == "MethodInvocation") {
          if(nodes_copy[adj_copy[src][0]] == "Primary") {
               string st = scope_check(adj_copy[src][0], 3);
               if(st == "this") {
                    string iden_name = scope_check(adj_copy[src][2], 3);
                    string class_name = find_class(node_to_sym_tab[src]);
                    int class_ind = class_map[class_name];
                    if(sym_tab[class_ind].find(iden_name) == sym_tab[class_ind].end()) {
                         fprintf(stderr, "Line number:%d Error: No method %s of class %s found\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
                         exit(0);
                    }
                    if(sym_tab[class_ind][iden_name].find("is_func") == sym_tab[class_ind][iden_name].end()) {
                         fprintf(stderr, "Line number:%d Error: No method %s of class %s found\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
                         exit(0);
                    }
                    node_to_type[src] = {sym_tab[class_ind][iden_name]["Type"], stoi(sym_tab[class_ind][iden_name]["Array_dims"])};
               }

               string str = "";
               for(int i = 3; i < adj_copy[src].size(); i++) {
                    str += scope_check(adj_copy[src][i], 0);
               }
          }
          else {
               string name = scope_check(adj_copy[src][0], 3);
               if(name == "System.out.println") {
                    string str = "";
                    for(int i = 1; i < adj_copy[src].size(); i++) {
                         str += scope_check(adj_copy[src][i], 0);
                    }
                    return "";
               }
               vector<string> vars;
               string curr_name = "";
               for(auto letter : name) {
                    if(letter == '.') {
                         vars.push_back(curr_name);
                         curr_name = "";
                         continue;
                    }
                    curr_name += letter;
               }
               vars.push_back(curr_name);
               if(vars.size() > 2) {
                    cerr << "Constraints dissatisfied. Chain of accesses present : " << name << "\n";
                    exit(0); 
               }
               else {
                    string class_name = "";
                    string iden_name = "";
                    string this_class = find_class(node_to_sym_tab[src]);
                    if(vars.size() == 1) {
                         class_name = this_class;
                         iden_name = vars[0];
                         // cerr << class_name << endl;
                    }
                    else {
                         pair<string, int> type = var_scope_check(node_to_sym_tab[src], vars[0], src);
                         string ref_type = type.first;
                         if(type.first == "")
                              ref_type = vars[0];
                         if(class_map.find(ref_type) == class_map.end()){
                              fprintf(stderr, "Line number:%d Error: Variable %s out of scope\n", line_no[src], (vars[0]).c_str());
                              exit(0);
                         }
                         class_name = ref_type;
                         iden_name = vars[1];
                    }
                    int class_ind = class_map[class_name];
                    if(sym_tab[class_ind].find(iden_name) == sym_tab[class_ind].end()) {
                         fprintf(stderr, "Line number:%d Error: No method %s of class %s found\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
                         exit(0);
                    }
                    if(sym_tab[class_ind][iden_name].find("is_func") == sym_tab[class_ind][iden_name].end()) {
                         fprintf(stderr, "Line number:%d Error: No method %s of class %s found\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
                         exit(0);
                    }
                    if(this_class != class_name) {
                         bool is_private = false;
                         for(auto elems : sym_tab[class_ind][iden_name]){
                              if(elems.second == "private")
                              {
                                   is_private = true;
                                   break;
                              }
                         }
                         if(is_private) {
                              fprintf(stderr, "Line number:%d Error: Member %s of class %s is private\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
                              exit(0);
                         }
                    }
                    node_to_type[src] = {sym_tab[class_ind][iden_name]["Type"], stoi(sym_tab[class_ind][iden_name]["Array_dims"])};
               }

               string str = "";
               for(int i = 1; i < adj_copy[src].size(); i++) {
                    str += scope_check(adj_copy[src][i], 0);
               }
          }
          return "";
     }
     else {
          string st = "";
          for(auto child : adj_copy[src]) 
               st += scope_check(child, type);
          return st;
     }
}

pair<string, int> type_check(int src) {
     // cerr << nodes_copy[src] << " " << src << endl;
     if(node_to_type.find(src) != node_to_type.end())
          return node_to_type[src];
     else if(nodes_copy[src] == "Literal") {
          if(nodes_copy[adj_copy[src][0]] == "INTEGER_LITERAL")
               return {"lit", 0};
          if(nodes_copy[adj_copy[src][0]] == "FLOATING_POINT_LITERAL")
               return {"float", 0};
          if(nodes_copy[adj_copy[src][0]] == "CHARACTER_LITERAL")
               return {"lit", 0};
          if(nodes_copy[adj_copy[src][0]] == "STRING_LITERAL")
               return {"String", 0};
          if(nodes_copy[adj_copy[src][0]] == "TEXT_BLOCK_LITERAL")
               return {"String", 0};
          if(nodes_copy[adj_copy[src][0]] == "BOOLEAN_LITERAL")
               return {"boolean", 0};
          if(nodes_copy[adj_copy[src][0]] == "NULL_LITERAL")
               return {"null", 0};
          return {"", 0};
     }
     else if(nodes_copy[src] == "ArrayAccess") {
          pair<string, int> type = type_check(adj_copy[src][2]);
          if(var_data_type(type.first) != "integer") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          type = type_check(adj_copy[src][0]);
          type.second = 0;
          return type;
     } 
     else if(nodes_copy[src] == "VariableDeclarator") {
          pair<string, int> type = type_check(adj_copy[src][0]);
          // cerr << type.first << " " << type.second << endl;
          if(adj_copy[src].size() == 3) {
               pair<string, int> type2 = type_check(adj_copy[src][2]);
               // cerr << type2.first << " " << type2.second << endl;
               if(type.second != type2.second) {
                    fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                    exit(0);
               }
               if(type_match(type.first, type2.first) == false) {
                    fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                    exit(0);
               }
          }
          return type;
     }
     else if(nodes_copy[src] == "ArrayCreationExpression") {
          string type = get_type(adj_copy[src][1]);
          int dims = get_dims(adj_copy[src][2]);
          if(adj_copy[src].size() > 3) {
               dims += get_dims(adj_copy[src][3]);
          }
          return {type, dims};
     }
     else if(nodes_copy[src] == "ForStatement" || nodes_copy[src] == "ForStatementNoShortIf") {
          for(auto child : adj_copy[src]) {
               if(nodes_copy[child] == "COLON")
                    break;
               if(nodes_copy[child] == "Expression") {
                    pair<string, int> type = type_check(child);
                    if(type.first != "boolean" || type.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               else {
                    pair<string, int> type = type_check(child);
               }
          }
          return {"", 0};
     }
     else if(nodes_copy[src] == "IfThenStatement" || nodes_copy[src] == "IfThenElseStatement" || nodes_copy[src] == "IfThenElseStatementNoShortIf") {
          for(auto child : adj_copy[src]) {
               if(nodes_copy[child] == "Expression") {
                    pair<string, int> type = type_check(child);
                    if(type.first != "boolean" || type.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               else {
                    pair<string, int> type = type_check(child);
               }
          }
          return {"", 0};
     }
     else if(nodes_copy[src] == "WhileStatement" || nodes_copy[src] == "WhileStatementNoShortIf"){
          for(auto child : adj_copy[src]) {
               if(nodes_copy[child] == "Expression") {
                    pair<string, int> type = type_check(child);
                    if(type.first != "boolean" || type.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               else {
                    pair<string, int> type = type_check(child);
               }
          }
          return {"", 0};
     }
     else if(nodes_copy[src] == "DoStatement") {
          for(auto child : adj_copy[src]) {
               if(nodes_copy[child] == "Expression") {
                    pair<string, int> type = type_check(child);
                    if(type.first != "boolean" || type.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               else {
                    pair<string, int> type = type_check(child);
               }
          }
          return {"", 0};
     }
     else if(nodes_copy[src] == "SwitchStatement") {
          for(auto child : adj_copy[src]) {
               if(nodes_copy[child] == "Expression") {
                    pair<string, int> type = type_check(child);
                    string data_type = var_data_type(type.first);
                    if(type.first == "boolean" || type.first == "object" || type.second != 0) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               else {
                    pair<string, int> type = type_check(child);
               }
          }
          return {"", 0};
     }
     else if(nodes_copy[src] == "ConditionalExpression") {
          if(adj_copy[src].size() == 5) {
               pair<string, int> type = type_check(adj_copy[src][0]);
               if(type.first != "boolean" || type.second != 0) {
                    fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                    exit(0);
               }
               type = type_check(adj_copy[src][2]);
               pair<string, int> type2 = type_check(adj_copy[src][4]);
               if(type.second != type2.second) {
                    fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                    exit(0);
               }
               string t1 = var_data_type(type.first);
               string t2 = var_data_type(type2.first);
               if(t1 != t2) {
                    if((t1 == "integer" && t2 == "decimal") || (t1 == "decimal" && t2 == "integer")) {
                         if(arithmetic_return(type.first) > arithmetic_return(type2.first)) {
                              return type;
                         }
                         else
                              return type2;
                    }
                    else {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
               if(t1 == "integer") {
                    if(arithmetic_return(type.first) > arithmetic_return(type2.first)) {
                         return type;
                    }
                    else
                         return type2;
               }
               if(t1 == "decimal") {
                    if(arithmetic_return(type.first) > arithmetic_return(type2.first)) {
                         return type;
                    }
                    else
                         return type2;
               }
               return type;
          }
          return type_check(adj_copy[src][0]);
     }
     else if(nodes_copy[src] == "ASSIGN" || nodes_copy[src] == "ASSIGN(=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj_copy[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second)
                    {
                         if(type.second != 0 || ptype.second != 0) {
                              if(type.first == "null" || ptype.first == "null")
                                   continue;
                         }
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         // cerr << "Mismatch here" << endl;
                         exit(0);
                    }
                    if(type_match(ptype.first, type.first) == false) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         // cerr << "Mismatch here 2" << endl;
                         exit(0);
                    }
               }
          }
          return ptype;
     }
     else if(nodes_copy[src] == "LESS_THAN" || nodes_copy[src] ==  "LESS_THAN_OR_EQUAL_TO" || nodes_copy[src] == "GREATER_THAN" || nodes_copy[src] == "GREATER_THAN_OR_EQUAL_TO" || nodes_copy[src] == "LESS_THAN(<)" || nodes_copy[src] ==  "LESS_THAN_OR_EQUAL_TO(<=)" || nodes_copy[src] == "GREATER_THAN(>)" || nodes_copy[src] == "GREATER_THAN_OR_EQUAL_TO(>=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj_copy[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second || type.second != 0)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if((t1 != "integer" && t1 != "decimal") || (t2 != "integer" && t2 != "decimal")){
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          return {"boolean", 0};
     }
     else if(nodes_copy[src] == "EQUAL_TO" || nodes_copy[src] == "NOT_EQUAL_TO" || nodes_copy[src] == "EQUAL_TO(==)" || nodes_copy[src] == "NOT_EQUAL_TO(!=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj_copy[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second)
                    {
                         if(type.second != 0 || ptype.second != 0) {
                              if(type.first == "null" || ptype.first == "null")
                                   continue;
                         }
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if(t2 == "null")
                    {
                         if(t1 == "String" || t1 == "object" || t1 == "null")
                              continue;
                    }
                    if(t1 == "null") {
                         if(t2 == "String" || t2 == "object" || t2 == "null")
                              continue;
                    }
                    if(t1 == "String" && t2 != "String") {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    else if(t1 == "boolean" && t2 != "boolean") {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    else if(t1 == "object" && t2 != "object") {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    else if(t1 == "integer" && (t2 != "integer" && t2 != "decimal")) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    else if(t1 == "decimal" && (t2 != "integer" && t2 != "decimal")) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          return {"boolean", 0};
     }
     else if(nodes_copy[src] == "BITWISE_AND" || nodes_copy[src] == "BITWISE_OR" || nodes_copy[src] == "BITWISE_XOR" || nodes_copy[src] == "BITWISE_AND(&)" || nodes_copy[src] == "BITWISE_OR(|)" || nodes_copy[src] == "BITWISE_XOR(^)" || nodes_copy[src] == "LEFT_SHIFT" || nodes_copy[src] == "RIGHT_SHIFT" || nodes_copy[src] == "UNSIGNED_RIGHT_SHIFT" || nodes_copy[src] == "LEFT_SHIFT(<<)" || nodes_copy[src] == "RIGHT_SHIFT(>>)" || nodes_copy[src] == "UNSIGNED_RIGHT_SHIFT(>>>)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj_copy[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second || type.second != 0)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if(t1 != "integer" || t2 != "integer") {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          return ptype;
     }
     else if(nodes_copy[src] == "OR_LOGICAL" || nodes_copy[src] == "AND_LOGICAL" || nodes_copy[src] == "OR_LOGICAL(||)" || nodes_copy[src] == "AND_LOGICAL(&&)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj_copy[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second || type.second != 0)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if(t1 != "boolean" || t2 != "boolean") {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          return {"boolean", 0};
     }
     else if(nodes_copy[src] == "PLUS" || nodes_copy[src] == "PLUS(+)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj_copy[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second || type.second != 0)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if((t1 != "integer" && t1 != "decimal" && t1 != "String") || (t2 != "integer" && t2 != "decimal" && t2 != "String")) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    if(arithmetic_return(ptype.first) < arithmetic_return(type.first)) {
                         ptype = type;
                    }
               }
          }
          return ptype;
     }
     else if(nodes_copy[src] == "MINUS" || nodes_copy[src] == "MULTIPLY" || nodes_copy[src] == "DIVIDE" || nodes_copy[src] == "MODULO" || nodes_copy[src] == "MINUS(-)" || nodes_copy[src] == "MULTIPLY(*)" || nodes_copy[src] == "DIVIDE(/)" || nodes_copy[src] == "MODULO(%)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj_copy[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second || type.second != 0)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    string t1 = var_data_type(ptype.first);
                    string t2 = var_data_type(type.first);
                    if((t1 != "integer" && t1 != "decimal") || (t2 != "integer" && t2 != "decimal")) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    if(arithmetic_return(ptype.first) < arithmetic_return(type.first)) {
                         ptype = type;
                    }
               }
          }
          return ptype;
     }
     else if(nodes_copy[src] == "PLUS_ASSIGN" || nodes_copy[src] == "PLUS_ASSIGN(+=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj_copy[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    if(type_match(ptype.first, type.first) == false) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          string data_type = var_data_type(ptype.first);
          if(data_type != "String" && data_type != "integer" && data_type != "decimal") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          return ptype;
     }
     else if(nodes_copy[src] == "MULTIPLY_ASSIGN" || nodes_copy[src] == "DIVIDE_ASSIGN" || nodes_copy[src] == "MOD_ASSIGN" || nodes_copy[src] == "MINUS_ASSIGN" || nodes_copy[src] == "MULTIPLY_ASSIGN(*=)" || nodes_copy[src] == "DIVIDE_ASSIGN(/=)" || nodes_copy[src] == "MOD_ASSIGN(%=)" || nodes_copy[src] == "MINUS_ASSIGN(-=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj_copy[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    if(type_match(ptype.first, type.first) == false) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          string data_type = var_data_type(ptype.first);
          if(data_type != "integer" && data_type != "decimal") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          return ptype;
     }
     else if(nodes_copy[src] == "LEFT_SHIFT_ASSIGN" || nodes_copy[src] == "RIGHT_SHIFT_ASSIGN" || nodes_copy[src] == "UNSIGNED_RIGHT_SHIFT_ASSIGN" || nodes_copy[src] == "AND_ASSIGN" || nodes_copy[src] == "OR_ASSIGN" || nodes_copy[src] == "XOR_ASSIGN" || nodes_copy[src] == "LEFT_SHIFT_ASSIGN(<<=)" || nodes_copy[src] == "RIGHT_SHIFT_ASSIGN(>>=)" || nodes_copy[src] == "UNSIGNED_RIGHT_SHIFT_ASSIGN(>>>=)" || nodes_copy[src] == "AND_ASSIGN(&=)" || nodes_copy[src] == "OR_ASSIGN(|=)" || nodes_copy[src] == "XOR_ASSIGN(^=)") {
          pair<string, int> ptype = {"", -1};
          for(auto child: adj_copy[src]) {
               pair<string, int> type = type_check(child);
               if(ptype.second == -1)
                    ptype = type;
               else {
                    if(type.second != ptype.second)
                    {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
                    if(type_match(ptype.first, type.first) == false) {
                         fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                         exit(0);
                    }
               }
          }
          string data_type = var_data_type(ptype.first);
          if(data_type != "integer") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          return ptype;
     } 
     else if(nodes_copy[src] == "PostIncrementExpression" || nodes_copy[src] == "PostDecrementExpression") {
          pair<string, int> type = type_check(adj_copy[src][0]);
          string t = var_data_type(type.first);
          if(type.second != 0 || t != "integer") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          return type;
     }
     else if(nodes_copy[src] == "PreIncrementExpression" || nodes_copy[src] == "PreDecrementExpression") {
          pair<string, int> type = type_check(adj_copy[src][1]);
          string t = var_data_type(type.first);
          if(type.second != 0 || t != "integer") {
               fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
               exit(0);
          }
          return type;
     }
     else if(nodes_copy[src] == "UnaryExpressionNotPlusMinus") {
          if(adj_copy[src].size() > 1) {
               pair<string, int> type = type_check(adj_copy[src][1]);
               string t = var_data_type(type.first);
               if(type.second != 0 || t != "integer") {
                    fprintf(stderr, "Line number:%d Error: Type mismatch\n", line_no[src]);
                    exit(0);
               }
               return type;
          }
          return type_check(adj_copy[src][0]);
     }
     else if(nodes_copy[src] == "ReturnStatement") {
          pair<string, int> type;
          if(adj_copy[src].size() == 2) {
               type = {"None", 0};
          }
          else {
               type = type_check(adj_copy[src][1]);
          }
          pair<string, int> func = find_func(node_to_sym_tab[src], node_to_sym_tab[src]);
          pair<string, int> ret_type = {sym_tab[func.second][func.first]["Type"], stoi(sym_tab[func.second][func.first]["Array_dims"])};
          if(ret_type.second != type.second) {
               fprintf(stderr, "Line number:%d Error: Wrong return type\n", line_no[src]);
               exit(0);
          }
          if(type_match(ret_type.first, type.first) == false) {
               fprintf(stderr, "Line number:%d Error: Wrong return type\n", line_no[src]);
               exit(0);
          } 
          sym_tab[func.second][func.first]["return"] = "True";
          return {"", 0};
     }
     else if(nodes_copy[src] == "Type"){
          return {"", 0};
     }
     else if(nodes_copy[src] == "ClassInstanceCreationExpression")
     {
          pair<string, int> type = type_check(adj_copy[src][1]);
          for(auto child : adj_copy[src]){
               pair<string, int> type2 = type_check(child);
          }
          return type;
     }
     else {
          pair<string, int> type = {"", 0};
          for(auto child : adj_copy[src]) {
               pair<string, int> ntype = type_check(child);
               if(type.first == "")
                    type = ntype;
               else if(ntype.first == "")
                    continue;
               else {
                    // cerr << nodes_copy[src] << " " << src << endl;
                    return {"", 0};
               }
          }
          // cerr << nodes_copy[src] << " " << src << endl;
          return type;
     }
}

void check_for_return() {
     for(auto class_name : class_map) {
          for(auto elem : sym_tab[class_name.second]) {
               if(elem.second.find("is_func") != elem.second.end()) {
                    if(elem.second.find("return") == elem.second.end()) {
                         if(elem.second["Type"] != "None") {
                              fprintf(stderr, "Line number:%d Error: Function did not return anything\n", stoi(elem.second["line_no"]));
                              exit(0);
                         }
                    }
               }
          }
     }
}

vector<pair<string, int>> arguments_fetch(int src) {
     vector<pair<string, int>> args;
     if(nodes_copy[src] == "Expression") {
          args.push_back(type_check(src));
     }
     else {
          args = arguments_fetch(adj_copy[src][0]);
          if(adj_copy[src].size() > 1) {
               vector<pair<string, int>> oth_args = arguments_fetch(adj_copy[src][2]);
               args.push_back(oth_args[0]);
          }
     }
     return args;
}

vector<string> get_params(int src) {
     vector<string> args;
     if(nodes_copy[src] == "MethodInvocation") {
          for(auto child: adj_copy[src]) {
               if(nodes_copy[child] == "ArgumentList") {
                    args = get_params(child);
                    break;
               }
          }
          return args;
     }
     if(nodes_copy[src] == "Expression") {
          pair<string, int> type = type_check(src);
          args.push_back(type.first);
     }
     else {
          args = get_params(adj_copy[src][0]);
          if(adj_copy[src].size() > 1) {
               vector<string> oth_args = get_params(adj_copy[src][2]);
               args.push_back(oth_args[0]);
          }
     }
     return args;
}

void check_func_params(int src) {
     if(nodes_copy[src] == "MethodInvocation") {
          string iden_name = "", class_name = "";
          vector<pair<string, int>> params;
          if(nodes_copy[adj_copy[src][0]] == "Primary") {
               string st = scope_check(adj_copy[src][0], 3);
               if(st == "this") {
                    iden_name = scope_check(adj_copy[src][2], 3);
                    class_name = find_class(node_to_sym_tab[src]);
                    int class_ind = class_map[class_name];

                    for(auto child : adj_copy[src]) {
                         if(nodes_copy[child] == "ArgumentList")
                         {
                              params = arguments_fetch(child);
                              break;
                         }
                    }
               }
          }
          else {
               string name = scope_check(adj_copy[src][0], 3);
               if(name == "System.out.println") {
                    iden_name = name;
                    for(auto child : adj_copy[src]) {
                         if(nodes_copy[child] == "ArgumentList")
                         {
                              params = arguments_fetch(child);
                              break;
                         }
                    }
               }
               else {
                    vector<string> vars;
                    string curr_name = "";
                    for(auto letter : name) {
                         if(letter == '.') {
                              vars.push_back(curr_name);
                              curr_name = "";
                              continue;
                         }
                         curr_name += letter;
                    }
                    vars.push_back(curr_name);
                    if(vars.size() > 2) {
                         cerr << "Constraints dissatisfied. Chain of accesses present : " << name << "\n";
                         exit(0); 
                    }
                    else {
                         string this_class = find_class(node_to_sym_tab[src]);
                         if(vars.size() == 1) {
                              class_name = this_class;
                              iden_name = vars[0];
                              // cerr << class_name << endl;
                         }
                         else {
                              pair<string, int> type = var_scope_check(node_to_sym_tab[src], vars[0], src);
                              string ref_type = type.first;
                              if(type.first == "")
                                   ref_type = vars[0];
                              class_name = ref_type;
                              iden_name = vars[1];
                         }
                         int class_ind = class_map[class_name];

                         for(auto child : adj_copy[src]) {
                              if(nodes_copy[child] == "ArgumentList")
                              {
                                   params = arguments_fetch(child);
                                   break;
                              }
                         }
                    }
               }
          }

          if(iden_name == "System.out.println") {
               if(params.size() != 1 || var_data_type(params[0].first) == "object" || params[0].second != 0) {
                    fprintf(stderr, "Line number:%d Error: Wrong function parameters\n", line_no[src]);
                    exit(0);
               }
          }
          else {
               int class_ind = class_map[class_name];
               int func_index = stoi(sym_tab[class_ind][iden_name]["func_param_index"]);
               if(params.size() != func_params[func_index].size()) {
                    fprintf(stderr, "Line number:%d Error: Wrong function parameters\n", line_no[src]);
                    exit(0);
               }
               for(int i = 0; i < params.size() ; i++) {
                    if(type_match(func_params[func_index][i].second["Type"], params[i].first) == false) {
                         fprintf(stderr, "Line number:%d Error: Wrong function parameters\n", line_no[src]);
                         exit(0);
                    }
                    if(stoi(func_params[func_index][i].second["Array_dims"]) != params[i].second) {
                         fprintf(stderr, "Line number:%d Error: Wrong function parameters\n", line_no[src]);
                         exit(0);
                    } 
               } 
          }
     }
     for(auto child : adj_copy[src]) {
          check_func_params(child);
     }
}

int array_dims_check(int src, int flag) {
     int total_dims = 0;
     if(nodes_copy[src] == "ArrayAccess") {
          if(nodes_copy[adj_copy[src][0]] == "Name") {
               pair<string, int> type = type_check(adj_copy[src][0]);
               total_dims = type.second;
          }
          else
               total_dims = array_dims_check(adj_copy[src][0], 1);
          for(int i = 1; i < adj_copy[src].size() ; i++)
               total_dims -= array_dims_check(adj_copy[src][i], 1);
          if(flag == 0 && total_dims != 0) {
               fprintf(stderr, "Line number:%d Error: Wrong number of array dimensions accessed\n", line_no[src]);
               exit(0);
          }
          return total_dims;
     }
     if(flag == 1) {
          if(nodes_copy[src] == "SQUARE_OPEN")
               return 1;
     }
     for(auto child: adj_copy[src])
          total_dims += array_dims_check(child, flag);
     return total_dims;
}

int get_class_size(string name) {
     int class_sym_ind = class_map[name];
     int size = 0;
     for(auto elem: sym_tab[class_sym_ind]) {
          if(elem.second.find("is_func") == elem.second.end()) {
               if(stoi(elem.second["Array_dims"]) > 0)
                    size += 8;
               else 
                    size += get_type_size(elem.second["Type"]);
          }
     }
     return size;
}

int func_param_size(int idx) {
     int size = 0;
     for(auto param: func_params[idx]) {
          if(stoi(param.second["Array_dims"]) > 0)
               size += 8;
          else 
               size += get_type_size(param.second["Type"]);
     }
     return size;
}

int get_total_size(int sym_ind){
     int total_size = 0;
     for(auto child: children[sym_ind])
          total_size += get_total_size(child);
     for(auto elem: sym_tab[sym_ind]) {
          if(elem.second.find("is_func") == elem.second.end()) {
               if(stoi(elem.second["Array_dims"]) > 0)
                    total_size += 8;
               else 
                    total_size += get_type_size(elem.second["Type"]);
          }
     }
     return total_size;
}
int get_func_size(string name, int src){
     int sym_ind = node_to_sym_tab[src];
     int sz = 0;
     for(auto elem: sym_tab[sym_ind]) {
          if(elem.first == name){
               if(elem.second.find("is_func") != elem.second.end()) {
                    sz = get_total_size(stoi(elem.second["sym_tab_ind"]));
                    sz -= func_param_size(stoi(elem.second["func_param_index"]));
                    break;
               }
          }
     }
     return sz;
}

int get_param_size(string name, int src){
     return 0;
}

int get_invoked_method_offset(string name, int src) {
     if(name == "System.out.println")
          return 0;
     vector<string> vars;
     string curr_name = "";
     for(auto letter : name) {
          if(letter == '.') {
               vars.push_back(curr_name);
               curr_name = "";
               continue;
          }
          curr_name += letter;
     }
     vars.push_back(curr_name);

     string class_name = "", iden_name = "";

     if(vars.size() == 1 || vars[0] == "this") {
          class_name = find_class(node_to_sym_tab[src]);
          if(vars.size() == 1)
               iden_name = vars[0];
          else 
               iden_name = vars[1];
     }
     else {
          pair<string, int> type = var_scope_check(node_to_sym_tab[src], vars[0], src);
          string ref_type = type.first;
          if(type.first == "")
               ref_type = vars[0];
          class_name = ref_type;
          iden_name = vars[1];
     }

     int class_ind = class_map[class_name];
     if(sym_tab[class_ind].find(iden_name) == sym_tab[class_ind].end()) {
          fprintf(stderr, "Line number:%d Error: No method %s of class %s found\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
          exit(0);
     }
     if(sym_tab[class_ind][iden_name].find("is_func") == sym_tab[class_ind][iden_name].end()) {
          fprintf(stderr, "Line number:%d Error: No method %s of class %s found\n", line_no[src], (iden_name).c_str(), (class_name).c_str());
          exit(0);
     }

     return get_total_size(stoi(sym_tab[class_ind][iden_name]["sym_tab_ind"])) - func_param_size(stoi(sym_tab[class_ind][iden_name]["func_param_index"]));
}

void set_class_offset(int index, map<string,int> m){
     int sym_ind = node_to_sym_tab[index];
     for(auto elem: m) {
          sym_tab[sym_ind][elem.first]["offset"] = to_string(elem.second);
     }
     return;
}

void obj_form_offset(string class_name, string name, int offset) {
     int sym_ind = class_map[class_name];
     sym_tab[sym_ind][name]["offset"] = to_string(offset);
}

void set_method_offset(int index, map<string,int> m){
     // int sym_ind = node_to_sym_tab[index];
     for(auto elem: m) {
          // cerr << elem.
          int sym_ind = var_sym(node_to_sym_tab[index], elem.first, index);
          sym_tab[sym_ind][elem.first]["offset"] = to_string(elem.second);
     }
     return;
}

int get_class_offset(int index, string name){
     int sym_ind = var_sym(node_to_sym_tab[index], name, index);
     return stoi(sym_tab[sym_ind][name]["offset"]);
}

int get_method_offset(string name, int index){
     int sym_ind = var_sym(node_to_sym_tab[index], name, index);
     return stoi(sym_tab[sym_ind][name]["offset"]);
}

pair<int, int> get_comp_method_offset(string name, int index) {
     vector<string> vars;
     string curr_var = "";
     for(auto c: name) {
          if(c == '.') {
               vars.push_back(curr_var);
               curr_var = "";
               continue;
          }
          curr_var += c;
     }
     vars.push_back(curr_var);

     if(vars.size() == 1) {
          int sym_ind = var_sym(node_to_sym_tab[index], name, index);
          if(sym_tab[sym_ind][name].find("is_global") == sym_tab[sym_ind][name].end()) 
               return {-1, stoi(sym_tab[sym_ind][name]["offset"])};
          else
               return {-2, stoi(sym_tab[sym_ind][name]["offset"])};
     }
     else {
          int sym_ind = var_sym(node_to_sym_tab[index], vars[0], index);
          string class_name = sym_tab[sym_ind][vars[0]]["Type"];
          int sym_ind_2 = class_map[class_name];
          return {stoi(sym_tab[sym_ind][vars[0]]["offset"]), stoi(sym_tab[sym_ind_2][vars[1]]["offset"])};
     }
}

string get_offset(string s,int n){
     // Purpose of this function is to
     // return the instruction given variable name and node number

     // offset shouold be a string with a sign

     // Will probably be used in name, 
     // field access and array access to obtain the appropriate pointers
     return "";
}

vector<string> get_num_globals(int index) {
     string class_name = find_class(node_to_sym_tab[index]);
     int sym_ind = class_map[class_name];
     vector<string> global_vars;
     for(auto elem: sym_tab[sym_ind]) {
          if(elem.second.find("is_func") == elem.second.end())
               global_vars.push_back(elem.first);
     }
     return global_vars;
}


vector<string> get_class_globals(string class_name) {
     int sym_ind = class_map[class_name];
     vector<string> global_vars;
     for(auto elem: sym_tab[sym_ind]) {
          if(elem.second.find("is_func") == elem.second.end())
               global_vars.push_back(elem.first);
     }
     return global_vars;
}

bool has_constructor(string class_name) {
     int sym_ind = class_map[class_name];
     for(auto elem: sym_tab[sym_ind]) {
          if(elem.second.find("is_func") != elem.second.end())
               if(elem.first == class_name)
                    return true;
     }
     return false;
}
int get_offset_lhs(string name, int index){
     return 0;
}
string gimme_class(string name, int index){
     // cerr << name << endl;
     int sym_ind = var_sym(node_to_sym_tab[index], name, index);
     // cerr << sym_ind << endl;
     return sym_tab[sym_ind][name]["Type"];
}
#endif