#include "sym_tab.hpp"
#include "utils.hpp"
#include <bits/stdc++.h>

using namespace std;

extern vector<string> nodes;
extern vector<int> line_no;
extern vector<vector<int>> adj;
extern int node_count;

extern vector<string> nodes_copy;
extern vector<vector<int>> adj_copy;

extern map<int, int> node_prod;
extern map<int, node_attr> node_attr_map;

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
extern map<int, int> parse_to_ast;

extern string return_reg;

extern int func_offset;
extern map<string, int> func_offset_map;

extern int class_offset;
extern map<string, int> class_offset_map;

extern int curr_offset;
extern map<string, int> curr_offset_map;

extern map<string, int> reg_to_node;
extern int offset;

extern string curr_class;

void postorder_x86(int n) {
    int reducer = node_prod[n];
    string name = nodes[n];
    if (name == "Literal") {
        node_attr_map[n].variable = get_new_temp();
        node_attr_map[n].val = nodes[adj[adj[n][0]][0]];
        node_attr_map[n].code = string("movq $") + node_attr_map[n].val + ", %rsi\n";
        node_attr_map[n].code += "pushq %rsi\n";
        switch (reducer) {
            case 0:
                node_attr_map[n].type = "int";
                node_attr_map[n].size = 8;
                break;
            case 1:
                node_attr_map[n].type = "float";
                node_attr_map[n].size = 8;
                break;
            case 2:
                node_attr_map[n].size = 8;
                break;
            case 3:
                node_attr_map[n].size = 2048;
                break;
            case 4:
                node_attr_map[n].size = 2048;
                break;
            case 5:
                node_attr_map[n].size = 8;
                break;
            case 6:
                node_attr_map[n].size = 8;
                break;
        }
        node_attr_map[n].label = get_new_label();
        node_attr_map[n].code += node_attr_map[n].label;
        node_attr_map[n].code += ": ";
        // // cout << node_attr_map[n].code;
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you in  literal\n";
        return;
    }
    if (name == "Type") {
        node_attr_map[n].size = node_attr_map[adj[n][0]].size;
        return;
    }
    if (name == "PrimitiveType") {
        switch (reducer) {
            case 0:
                node_attr_map[n].size = node_attr_map[adj[n][0]].size;
                break;
            case 1:
                node_attr_map[n].size = 8;
                break;
            case 2:
                node_attr_map[n].size = 8;
                break;
        }
        return;
    }
    if (name == "NumericType") {
        node_attr_map[n].size = node_attr_map[adj[n][0]].size;
        return;
    }
    if (name == "IntegralType") {
        node_attr_map[n].size = 8;
        return;
    }
    if (name == "FloatingPointType") {
        node_attr_map[n].size = 8;
        return;
    }
    if (name == "ReferenceType") {
        node_attr_map[n].size = node_attr_map[adj[n][0]].size;
        return;
    }
    if (name == "ClassOrInterfaceType") {
        node_attr_map[n].type = node_attr_map[adj[n][0]].variable;
        return;
    }
    if (name == "ClassType") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        return;
    }
    if (name == "InterfaceType") {
        node_attr_map[n].size = -1;
        return;
    }
    if (name == "ArrayType") {
        node_attr_map[n].size = -1;
        return;
    }
    if (name == "Name") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        return;
    }
    if (name == "SimpleName") {
        node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
        return;
    }
    if (name == "QualifiedName") {
        node_attr_map[n].variable = node_attr_map[adj[n][0]].variable + "." + nodes[adj[adj[n][2]][0]];
        return;
    }
    if (name == "CompilationUnit") {
        // implementation pending
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        // cout << node_attr_map[n].code << "\n\n";
        return;
    }
    if (name == "ImportDeclarations") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }
    if (name == "TypeDeclarations") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        // cout << node_attr_map[n].code << "\n\n";
        return;
    }
    if (name == "PackageDeclaration") {
        return;
    }
    if (name == "SingleTypeImportDeclaration") {
        return;
    }
    if (name == "TypeImportOnDemandDeclaration") {
        return;
    }
    if (name == "TypeDeclaration") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        // cout << node_attr_map[n].code << "\n\n";
        return;
    }
    if (name == "MethodTypeDeclaration") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }
    if (name == "Modifiers") {
        for (int i = 1; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }
    if (name == "Modifier") {
        return;
    }
    if (name == "ClassDeclaration") {
        string class_name;
        string extension = ".class\n";
        switch (reducer) {
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
        // node_attr_map[n].code = class_name;
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }

        // cout << node_attr_map[n].code << "\n";
        return;
    }
    if (name == "Super") {
        // for (int i = 0; i < adj[n].size(); i++) {
        //     node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        // }
        return;
    }
    if (name == "Interfaces") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }
    if (name == "InterfaceTypeList") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }
    if (name == "ClassBody") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        // cout << node_attr_map[n].code << "\n\n";
        return;
    }
    if (name == "ClassBodyDeclarations") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }
    if (name == "ClassBodyDeclaration") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }
    if (name == "ClassMemberDeclaration") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }
    if (name == "FieldDeclaration") {
        // for (int i = 0; i < adj[n].size(); i++) {
        //     node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        // }
        // switch (reducer) {
        //     case 0:
        //         for (auto it : curr_offset_map) {
        //             curr_offset += node_attr_map[adj[n][1]].size;
        //             curr_offset_map[it.first] = curr_offset;
        //         }
        //         set_class_offset(parse_to_ast[n], curr_offset_map);
        //         node_attr_map[n].label = node_attr_map[adj[n][2]].label;
        //         break;
        //     case 1:
        //         for (auto it : curr_offset_map) {
        //             curr_offset += node_attr_map[adj[n][0]].size;
        //             curr_offset_map[it.first] = curr_offset;
        //         }
        //         set_class_offset(parse_to_ast[n], curr_offset_map);
        //         node_attr_map[n].label = node_attr_map[adj[n][1]].label;
        //         break;
        // }
        return;
    }
    if (name == "VariableDeclarators") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        node_attr_map[n].label = get_new_label();
        node_attr_map[n].code += node_attr_map[n].label;
        node_attr_map[n].code += ": ";
        return;
    }
    if (name == "VariableDeclarator") {
        curr_offset_map[node_attr_map[adj[n][0]].variable] = -1;
        string code = "pushq %rsi\n";
        int offset = 0;
        for (auto it : curr_offset_map) {
            if (curr_offset_map[it.first] != -1) {
                continue;
            }
            curr_offset += 8;
            curr_offset_map[it.first] = curr_offset;
            // cout << it.first << " " << curr_offset << "\n";
        }
        set_method_offset(parse_to_ast[n], curr_offset_map);
        switch (reducer) {
            case 0:
                break;
            case 1:
                string var0 = node_attr_map[adj[n][0]].variable;
                string var1 = node_attr_map[adj[n][2]].variable;
                code += node_attr_map[adj[n][0]].code;
                code += node_attr_map[adj[n][2]].code;
                if (!node_attr_map[adj[n][2]].dims.empty()) {
                    int sym_ind = var_sym(node_to_sym_tab[parse_to_ast[n]], var0, parse_to_ast[n]);
                    string prev_temp = "";
                    int curr_reg = 11;

                    for (int ii = 0; ii < node_attr_map[adj[n][2]].dims.size(); ii++) {
                        // code += "add symboltable(" + var0 + "." + "dim" + to_string(ii) + "," + node_attr_map[adj[n][2]].dims[ii] + ")\n";
                        // sym_tab[sym_ind][var0]["dim" + to_string(ii)] = node_attr_map[adj[n][2]].dims[ii];
                        // curr_offset += 8;
                        sym_tab[sym_ind][var0]["dim" + to_string(ii)] = to_string(curr_offset);

                        if (ii == 0) {
                            // prev_temp = node_attr_map[adj[n][2]].dims[ii];
                            // curr_offset -= 8;
                            code += "popq %rbx\n";
                            code += "movq %rbx, %r" + to_string(curr_reg) + "\n";
                            curr_reg++;
                        } else {
                            // string temp = get_new_temp();
                            // code += temp + " = " + prev_temp + "*" + node_attr_map[adj[n][2]].dims[ii] + "\n";
                            // prev_temp = temp;
                            // curr_offset -= 8;
                            code += "popq %rcx\n";
                            code += "movq %rcx, %r" + to_string(curr_reg) + "\n";
                            curr_reg++;
                            code += "imulq %rcx, %rbx\n";
                        }
                    }
                    int dimension = node_attr_map[adj[n][2]].dims.size() - 1;
                    for (int i = 11; i < curr_reg; i++) {
                        curr_offset += 8;
                        sym_tab[sym_ind][var0]["dim" + to_string(dimension)] = to_string(curr_offset);
                        dimension--;
                        code += "pushq %rsi\n";
                        code += "movq %r" + to_string(i) + ", -" + to_string(curr_offset) + "(%rbp)\n";
                    }
                    // string temp = get_new_temp();
                    // code += temp + " = " + prev_temp + "*" + to_string(get_type_size(sym_tab[sym_ind][var0]["Type"])) + "\n";
                    if(curr_offset % 16 != 0)
                        code += "imulq $8, %rbx\npushq %r10\nmovq %rbx, %rdi\ncall malloc\npopq %r10\n";
                    else 
                        code += "imulq $8, %rbx\npushq %r10\npushq %r10\nmovq %rbx, %rdi\ncall malloc\npopq %r10\npopq %r10\n";
                    // code += "call allocmem " + temp + "\n";
                    // code += var0 + " = popq stack\n";
                    // add all dimensions
                    offset = get_method_offset(var0, parse_to_ast[n]);
                    offset = -offset;
                    code += "movq %rax, " + to_string(offset) + "(%rbp)\n";

                } else {
                    code += "popq %rbx\n";
                    offset = get_method_offset(var0, parse_to_ast[n]);
                    offset = -offset;
                    code += "movq %rbx, " + to_string(offset) + "(%rbp)\n";
                }
                // if (!node_attr_map[adj[n][2]].dims.empty()){
                //      code += "add symtable(" + var0 + ", " + var1 + ".dims)\n";
                // }
                break;
        }
        node_attr_map[n].code = code;

        return;
    }
    if (name == "VariableDeclaratorId") {
        switch (reducer) {
            case 0:
                node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                break;
            case 1:
                node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
                break;
        }
        return;
    }
    if (name == "VariableInitializer") {
        switch (reducer) {
            case 0:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
            case 1:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
        }
        return;
    }

    if (name == "MethodDeclaration") {
        curr_offset = class_offset;
        curr_offset_map = class_offset_map;

        int frame_size;

        if(node_attr_map[adj[n][0]].variable == "main");
        else
            node_attr_map[adj[n][0]].variable = curr_class + "." + node_attr_map[adj[n][0]].variable;

        switch (reducer) {
            case 0:
                string code = node_attr_map[adj[n][0]].variable + ":\n";

                code += "pushq %rbp\n";
                code += "movq %rsp, %rbp\n";

                code += node_attr_map[adj[n][0]].code;
                code += node_attr_map[adj[n][1]].code;

                code += "leave\nret\n";

                node_attr_map[n].code = code;

                node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
                break;
        }

        // cout << node_attr_map[n].code << "\n\n";
        return;
    }

    if (name == "MethodHeader") {
        class_offset = curr_offset;
        class_offset_map = curr_offset_map;

        curr_offset_map.clear();

        switch (reducer) {
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
    if (name == "MethodDeclarator") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }

        curr_offset = 0;
        map<string, int> m;
        int curr = 0;
        switch (reducer) {
            case 0:
                node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                if (node_attr_map[n].variable == "main") {
                    vector<string> globals = get_num_globals(parse_to_ast[n]);
                    int num_globals = globals.size();
                    string code = "";
                    int loc_offset = 0;
                    string class_name = find_class(node_to_sym_tab[parse_to_ast[n]]);
                    for (int i = 0; i < num_globals; i++) {
                        if (i == 0) {
                            int this_off = -curr_offset - 8;
                            code += "movq $" + to_string(this_off) + ", %r8\n";
                            code += "addq %rbp, %r8\n";
                        }
                        curr_offset += 8;
                        code += "pushq %rsi\n";
                        obj_form_offset(class_name, globals[i], loc_offset);
                        loc_offset -= 8;
                    }
                    node_attr_map[n].code = code;
                    break;
                }
                for (int i = 0; i < node_attr_map[adj[n][2]].sizes.size(); i++) {
                    m[node_attr_map[adj[n][2]].args[i]] = -8 * i - 16;
                }
                set_method_offset(parse_to_ast[n], m);
                // for (int i = 0; i < node_attr_map[adj[n][2]].sizes.size(); i++) {
                //     // // cout << node_attr_map[adj[n][2]].sizes[i] << endl;
                //     node_attr_map[n].code += "move" + to_string(node_attr_map[adj[n][2]].sizes[i]);
                //     node_attr_map[n].code += string(" ") + to_string(curr) + "(%rbp) " + node_attr_map[adj[n][2]].args[i] + "\n";
                //     curr += node_attr_map[adj[n][2]].sizes[i];
                //     // // cout << curr << endl;
                // }
                break;
            case 1:
                node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                break;
            case 2:
                node_attr_map[n].variable = node_attr_map[adj[n][0]].variable;
                break;
        }
        return;
    }

    if (name == "FormalParameterList") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        switch (reducer) {
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
        return;
    }

    if (name == "FormalParameter") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        // // cout<<"Hello\n";
        switch (reducer) {
            case 0:
                node_attr_map[n].sizes.push_back(node_attr_map[adj[n][0]].size);
                node_attr_map[n].args.push_back(node_attr_map[adj[n][1]].variable);
                break;
            case 1:
                node_attr_map[n].sizes.push_back(node_attr_map[adj[n][1]].size);
                node_attr_map[n].args.push_back(node_attr_map[adj[n][2]].variable);
                break;
        }
        // // cout << node_attr_map[n].code;
        return;
    }

    if (name == "Throws") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }

    if (name == "ClassTypeList") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }

    if (name == "MethodBody") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }

        // cout << node_attr_map[n].code << "\n\n";
        // node_attr_map[n].code += "nop\n";
        return;
    }
    if (name == "StaticInitializer") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }
    if (name == "ConstructorDeclaration") {
        string code = "constructor\n";
        for (int i = 0; i < adj[n].size(); i++) {
            code = code + node_attr_map[adj[n][i]].code;
        }
        code = code + "endconstructor\n";
        node_attr_map[n].code = code;
        return;
    }

    if (name == "ConstructorDeclarator") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        int curr = 0;
        switch (reducer) {
            case 1:
                node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                break;
            case 0:
                node_attr_map[n].variable = nodes[adj[adj[n][0]][0]];
                break;
        }
        return;
    }

    if (name == "ConstructorBody") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        return;
    }

    if (name == "ExplicitConstructorInvocation") {
        return;
    }

    if (name == "InterfaceDeclaration") {
        return;
    }
    if (name == "ExtendsInterfaces") {
        return;
    }
    if (name == "InterfaceBody") {
        return;
    }
    if (name == "InterfaceMemberDeclarations") {
        return;
    }
    if (name == "InterfaceMemberDeclaration") {
        return;
    }
    if (name == "ConstantDeclaration") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        return;
    }
    if (name == "AbstractMethodDeclaration") {
        switch (reducer) {
            case 0:
                string code = "func" + node_attr_map[adj[n][0]].variable + "\n" + node_attr_map[adj[n][0]].code + node_attr_map[adj[n][1]].code + "endfunc\n";
                node_attr_map[n].code = code;
                // node_attr_map[n].variable = node_atVariableInitializer:tr_map[adj[n][0]].variable;
                break;
        }
        return;
    }
    if (name == "ArrayInitializer") {
        switch (reducer) {
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
        return;
    }
    if (name == "VariableInitializers") {
        switch (reducer) {
            case 0:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
            case 1:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].size = node_attr_map[adj[n][0]].size + node_attr_map[adj[n][2]].size;
                string temp = get_new_temp();
                string off = to_string(get_method_offset(node_attr_map[n].variable, parse_to_ast[n]));
                node_attr_map[n].code += "movq %rsi, " + off + "(%%rbp)\n";
                node_attr_map[n].code += string("add %rsi") + "," + to_string(node_attr_map[n].size) + "\n";
                node_attr_map[n].code += "*" + temp + " = " + node_attr_map[adj[n][2]].variable + "\n";
                break;
        }
        return;
    }
    if (name == "Block") {
        switch (reducer) {
            case 0:
                node_attr_map[n].label = get_new_label();
                node_attr_map[n].code = node_attr_map[n].label + ": ";
                break;
            case 1:
                node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                node_attr_map[n].code = node_attr_map[adj[n][1]].code;
                break;
        }
        return;
    }
    if (name == "BlockStatements") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        node_attr_map[n].label = node_attr_map[adj[n][adj[n].size() - 1]].label;
        return;
    }
    if (name == "BlockStatement") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        node_attr_map[n].label = node_attr_map[adj[n][0]].label;
        return;
    }

    if (name == "MethodBlock") {
        switch (reducer) {
            case 0:
                node_attr_map[n].label = get_new_label();
                node_attr_map[n].code = node_attr_map[n].label + ": ";
                break;
            case 1:
                node_attr_map[n].label = node_attr_map[adj[n][1]].label;
                node_attr_map[n].code = node_attr_map[adj[n][1]].code;
                break;
        }
        // cout << "mb\n" << node_attr_map[n].code << "\n\n";
        return;
    }

    if (name == "MethodBlockStatements") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        node_attr_map[n].label = node_attr_map[adj[n][adj[n].size() - 1]].label;
        // // cout << "mbs\n" << node_attr_map[n].code <<"\n\n" ;
        return;
    }

    if (name == "MethodBlockStatement") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        node_attr_map[n].label = node_attr_map[adj[n][0]].label;
        // // cout << "mb\n" << node_attr_map[n].code <<"\n\n" ;
        return;
    }

    if (name == "LocalVariableDeclarationStatement") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        node_attr_map[n].label = node_attr_map[adj[n][0]].label;
        // cout << "\n\n" << node_attr_map[n].code << "\n\n";
        return;
    }

    if (name == "LocalVariableDeclaration") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        switch (reducer) {
            case 0:
                node_attr_map[n].type = node_attr_map[adj[n][0]].type;
                node_attr_map[n].size = node_attr_map[adj[n][0]].size;
                break;
            case 1:
                node_attr_map[n].type = node_attr_map[adj[n][1]].type;
                node_attr_map[n].size = node_attr_map[adj[n][1]].size;
                break;
        }
        node_attr_map[n].label = node_attr_map[adj[n][adj[n].size() - 1]].label;
        // cout << "\n\n" << node_attr_map[n].code << "\n\n";
        return;
    }

    if (name == "VariableModifier") {
        return;
    }

    if (name == "Statement") {
        node_attr_map[n].label = node_attr_map[adj[n][0]].label;
        node_attr_map[n].code = node_attr_map[adj[n][0]].code;
        return;
    }
    if (name == "StatementNoShortIf") {
        node_attr_map[n].label = node_attr_map[adj[n][0]].label;
        node_attr_map[n].code = node_attr_map[adj[n][0]].code;
        return;
    }
    if (name == "StatementWithoutTrailingSubstatement") {
        node_attr_map[n].label = node_attr_map[adj[n][0]].label;
        node_attr_map[n].code = node_attr_map[adj[n][0]].code;

        // cout << node_attr_map[n].code << "\n\n";
        return;
    }
    if (name == "EmptyStatement") {
        node_attr_map[n].label = get_new_label();
        node_attr_map[n].code = node_attr_map[n].label + ": ";
        return;
    }
    if (name == "LabeledStatement") {
        // pick label from symbol table
        node_attr_map[n].label = node_attr_map[adj[n][2]].label;
        node_attr_map[n].code = nodes[adj[adj[n][0]][0]] + ": " + node_attr_map[adj[n][2]].code;
        return;
    }
    if (name == "LabeledStatementNoShortIf") {
        // pick label from symbol table
        node_attr_map[n].label = node_attr_map[adj[n][2]].label;
        node_attr_map[n].code = nodes[adj[adj[n][0]][0]] + ": " + node_attr_map[adj[n][2]].code;
        return;
    }
    if (name == "ExpressionStatement") {
        node_attr_map[n].variable = get_new_temp();
        node_attr_map[n].label = get_new_label();
        node_attr_map[n].code = node_attr_map[adj[n][0]].code;
        node_attr_map[n].code += "popq %rsi\n";
        node_attr_map[n].code += node_attr_map[n].label + ": ";
        return;
    }
    if (name == "StatementExpression") {
        node_attr_map[n].code = node_attr_map[adj[n][0]].code;
        return;
    }
    if (name == "IfThenStatement") {
        string label = get_new_label();
        node_attr_map[n].label = node_attr_map[adj[n][4]].label;
        string code = "";
        code += node_attr_map[adj[n][2]].code;
        code += "popq %rsi\n";
        code += "movq $0, %rax\n";
        code += "cmp %rsi, %rax\n";
        code += "jne " + label + "\n";
        code += "jmp " + node_attr_map[adj[n][4]].label + "\n";
        code += label + ": ";
        code += node_attr_map[adj[n][4]].code;
        node_attr_map[n].code = code;
        //  + "if " + node_attr_map[adj[n][2]].variable + " jmp " + label + "\n" + "jmp " +
        //                         node_attr_map[adj[n][4]].label + "\n" + label + ": " + node_attr_map[adj[n][4]].code;
        return;
    }
    if (name == "IfThenElseStatement") {
        string label1 = get_new_label();
        string label2 = get_new_label();

        node_attr_map[n].label = node_attr_map[adj[n][6]].label;
        string code = "";
        code += node_attr_map[adj[n][2]].code;
        code += "popq %rsi\n";
        code += "movq $0, %rax\n";
        code += "cmp %rsi, %rax\n";
        code += "jne " + label1 + "\n";
        code += "jmp " + label2 + "\n";
        code += label1 + ": ";
        code += node_attr_map[adj[n][4]].code;
        code += "jmp " + node_attr_map[adj[n][6]].label + "\n";
        code += label2 + ": ";
        code += node_attr_map[adj[n][6]].code;
        node_attr_map[n].code = code;
        // node_attr_map[n].code = node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " jmp " + label1 + "\n" + "jmp " + label2 +
        // "\n" +
        //                         label1 + ": " + node_attr_map[adj[n][4]].code + "jmp " + node_attr_map[adj[n][6]].label + "\n" + label2 + ": " +
        //                         node_attr_map[adj[n][6]].code;
        return;
    }
    if (name == "IfThenElseStatementNoShortIf") {
        string label1 = get_new_label();
        string label2 = get_new_label();

        node_attr_map[n].label = node_attr_map[adj[n][6]].label;
        string code = "";
        code += node_attr_map[adj[n][2]].code;
        code += "popq %rsi\n";
        code += "movq $0, %rax\n";
        code += "cmp %rsi, %rax\n";
        code += "jne " + label1 + "\n";
        code += "jmp " + label2 + "\n";
        code += label1 + ": ";
        code += node_attr_map[adj[n][4]].code;
        code += "jmp " + node_attr_map[adj[n][6]].label + "\n";
        code += label2 + ": ";
        code += node_attr_map[adj[n][6]].code;
        node_attr_map[n].code = code;
        return;
    }
    if (name == "SwitchStatement") {
        node_attr_map[n].label = node_attr_map[adj[n][4]].label;
        node_attr_map[n].code = node_attr_map[adj[n][2]].code + node_attr_map[adj[n][4]].code;

        while (node_attr_map[n].code.find("s-w-i-t-c-h") != string::npos)
            node_attr_map[n].code.replace(node_attr_map[n].code.find("s-w-i-t-c-h"), 11, node_attr_map[adj[n][2]].variable);

        while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
            node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, node_attr_map[n].label);
        return;
    }
    if (name == "SwitchBlock") {
        switch (reducer) {
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
                node_attr_map[n].code = node_attr_map[n].label + ": ";
                break;
            case 3:
                node_attr_map[n].label = get_new_label();
                node_attr_map[n].code = node_attr_map[n].label + ": ";
                break;
        }
    }
    if (name == "SwitchBlockStatementGroups") {
        for (auto i : adj[n]) {
            if (node_attr_map[i].variable == "")
                node_attr_map[n].code = node_attr_map[i].code + node_attr_map[n].code;
            else {
                node_attr_map[n].code = node_attr_map[n].code + node_attr_map[i].code;
                node_attr_map[n].label = node_attr_map[i].label;
            }
        }
        return;
    }
    if (name == "SwitchBlockStatementGroup") {
        string label = get_new_label();
        string child_label = node_attr_map[adj[n][0]].label;
        node_attr_map[n].code = node_attr_map[adj[n][0]].code;

        string variable = "";
        bool flag = false;

        for (int it = 0; it != child_label.size(); it++) {
            if (child_label[it] != ',')
                variable.push_back(child_label[it]);
            else {
                if (variable[0] == 't')
                    node_attr_map[n].code += string("if") + " s-w-i-t-c-h == " + variable + " jmp " + label + "\n";
                if (variable[0] == 'D')
                    flag = true;
                variable = "";
            }
        }
        node_attr_map[n].code += "jmp ";
        node_attr_map[n].code += node_attr_map[adj[n][1]].label;
        node_attr_map[n].code += "\n";
        node_attr_map[n].code += label;
        node_attr_map[n].code += ": ";
        node_attr_map[n].code += node_attr_map[adj[n][1]].code;

        if (!flag)
            node_attr_map[n].label = node_attr_map[adj[n][1]].label;
        else {
            string new_label = get_new_label();
            string code = node_attr_map[adj[n][1]].code;
            while ((code.size() != 0) && (*code.rbegin() != '\n'))
                code.pop_back();
            node_attr_map[n].code += code;
            node_attr_map[n].code += new_label;
            node_attr_map[n].code += ": ";
            node_attr_map[n].label = new_label;
            node_attr_map[n].variable = "True";
        }
        // // cout << "statgroup\n" << node_attr_map[n].code <<"\nfinish\n";
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }
    if (name == "SwitchLabels") {
        for (auto i : adj[n]) {
            node_attr_map[n].label += (node_attr_map[i].label + ",");
            node_attr_map[n].code += (node_attr_map[i].code);
        }
        return;
    }
    if (name == "SwitchLabel") {
        switch (reducer) {
            case 0:
                node_attr_map[n].label = node_attr_map[adj[n][1]].variable;
                node_attr_map[n].code = node_attr_map[adj[n][1]].code;
                break;

            case 1:
                node_attr_map[n].label = string("D");
                break;
        }
    }
    if (name == "WhileStatement") {
        string stat_label = get_new_label();
        string cond_label = get_new_label();
        node_attr_map[n].label = get_new_label();

        // node_attr_map[n].code = cond_label + ": " + node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " jmp " + stat_label +
        //                         "\njmp " + node_attr_map[n].label + "\n" + stat_label + ": " + node_attr_map[adj[n][4]].code + "jmp " + cond_label + "\n"
        //                         + node_attr_map[n].label + ": ";
        string code = "";
        code += cond_label + ": ";
        code += node_attr_map[adj[n][2]].code;
        code += "popq %rsi\n";
        code += "movq $0, %rax\n";
        code += "cmp %rsi, %rax\n";
        code += "jne " + stat_label + "\n";
        code += "jmp " + node_attr_map[n].label + "\n";
        code += stat_label + ": ";
        code += node_attr_map[adj[n][4]].code;
        code += "jmp " + cond_label + "\n";
        code += node_attr_map[n].label + ": ";
        node_attr_map[n].code = code;

        while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
            node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, cond_label);
        while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
            node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, node_attr_map[n].label);
        return;
    }
    if (name == "WhileStatementNoShortIf") {
        string stat_label = get_new_label();
        string cond_label = get_new_label();
        node_attr_map[n].label = get_new_label();

        // node_attr_map[n].code = cond_label + ": " + node_attr_map[adj[n][2]].code + "if " + node_attr_map[adj[n][2]].variable + " jmp " + stat_label +
        //                         "\njmp " + node_attr_map[n].label + "\n" + stat_label + ": " + node_attr_map[adj[n][4]].code + "jmp " + cond_label + "\n"
        //                         + node_attr_map[n].label + ": ";
        string code = "";
        code += cond_label + ": ";
        code += node_attr_map[adj[n][2]].code;
        code += "popq %rsi\n";
        code += "movq $0, %rax\n";
        code += "cmp %rsi, %rax\n";
        code += "jne " + stat_label + "\n";
        code += "jmp " + node_attr_map[n].label + "\n";
        code += stat_label + ": ";
        code += node_attr_map[adj[n][4]].code;
        code += "jmp " + cond_label + "\n";
        code += node_attr_map[n].label + ": ";
        node_attr_map[n].code = code;

        while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
            node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, cond_label);
        while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
            node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, node_attr_map[n].label);
        return;
    }
    if (name == "DoStatement") {
        string label1 = get_new_label();
        string label2 = get_new_label();

        // node_attr_map[n].label = label2;
        // node_attr_map[n].code = label1 + ": " + node_attr_map[adj[n][1]].code + node_attr_map[adj[n][4]].code + "if " + node_attr_map[adj[n][4]].variable +
        //                         " jmp " + label1 + "\n" + label2 + ": ";
        string code = "";
        code += label1 + ": ";
        code += node_attr_map[adj[n][1]].code;
        code += node_attr_map[adj[n][4]].code;
        code += "popq %rsi\n";
        code += "movq $0, %rax\n";
        code += "cmp %rsi, %rax\n";
        code += "jne " + label1 + "\n";
        code += label2 + ": ";
        node_attr_map[n].code = code;
        while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
            node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, node_attr_map[adj[n][1]].label);
        while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
            node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, label2);

        return;
    }
    if (name == "ForStatement") {
        string L1 = get_new_label();
        string L2 = get_new_label();
        string L3 = get_new_label();
        string code = "";
        // // cout << "ForStatement\n";

        switch (reducer) {
            case 0:
                node_attr_map[n].label = get_new_label();
                code = node_attr_map[adj[n][2]].code;
                code += "jmp " + L3 + "\n";
                code += L1 + ": ";
                code += node_attr_map[adj[n][8]].code;
                code += L2 + ": ";
                code += node_attr_map[adj[n][6]].code;
                code += L3 + ": ";
                code += node_attr_map[adj[n][4]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;
            case 1:
                node_attr_map[n].label = get_new_label();
                code = node_attr_map[adj[n][2]].code;
                code += "jmp " + L3 + "\n";
                code += L1 + ": ";
                code += node_attr_map[adj[n][7]].code;
                code += L2 + ": ";
                code += node_attr_map[adj[n][5]].code;
                code += L3 + ": ";
                code += "jmp " + L1 + "\n";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 2:
                node_attr_map[n].label = get_new_label();
                code += "jmp " + L3 + "\n";
                code += L1 + ": ";
                code += node_attr_map[adj[n][7]].code;
                code += L2 + ": ";
                code += node_attr_map[adj[n][5]].code;
                code += L3 + ": ";
                code += node_attr_map[adj[n][3]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 3:
                node_attr_map[n].label = get_new_label();
                code = node_attr_map[adj[n][2]].code;
                code += "jmp " + L3 + "\n";
                code += L1 + ": ";
                code += node_attr_map[adj[n][7]].code;
                code += L2 + ": ";
                code += L3 + ": ";
                code += node_attr_map[adj[n][4]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 4:
                node_attr_map[n].label = get_new_label();
                code += "jmp " + L3 + "\n";
                code += L1 + ": ";
                code += node_attr_map[adj[n][6]].code;
                code += L2 + ": ";
                code += node_attr_map[adj[n][4]].code;
                code += L3 + ": ";
                code += "jmp " + L1 + "\n";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 5:
                node_attr_map[n].label = get_new_label();
                code += "jmp " + L3 + "\n";
                code += L1 + ": ";
                code += node_attr_map[adj[n][6]].code;
                code += L2 + ": ";
                code += L3 + ": ";
                code += node_attr_map[adj[n][3]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 6:
                node_attr_map[n].label = get_new_label();
                code = node_attr_map[adj[n][2]].code;
                code += L1 + ": ";
                code += node_attr_map[adj[n][6]].code;
                code += "jmp " + L1 + "\n";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 7:
                node_attr_map[n].label = get_new_label();
                code += L1 + ": ";
                code += node_attr_map[adj[n][5]].code;
                code += "jmp " + L1 + "\n";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;
        }
        // cout << "\n\n" << node_attr_map[n].code << "\n\n";
        return;
    }
    if (name == "ForStatementNoShortIf") {
        string L1 = get_new_label();
        string L2 = get_new_label();
        string L3 = get_new_label();
        string code = "";
        // // cout << "ForStatement\n";

        switch (reducer) {
            case 0:
                node_attr_map[n].label = get_new_label();
                code = node_attr_map[adj[n][2]].code;
                code += node_attr_map[adj[n][4]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += "jmp " + L3 + "\n";
                code += L1 + ": ";
                code += node_attr_map[adj[n][8]].code;
                code += L2 + ": ";
                code += node_attr_map[adj[n][6]].code;
                code += node_attr_map[adj[n][4]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += "jmp " + L3 + "\n";
                code += L3 + ": ";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;
            case 1:
                node_attr_map[n].label = get_new_label();
                code = node_attr_map[adj[n][2]].code;
                code += L1 + ": ";
                code += node_attr_map[adj[n][7]].code;
                code += L2 + ": ";
                code += node_attr_map[adj[n][5]].code;
                code += "jmp " + L1 + "\n";
                code += L3 + ": ";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 2:
                node_attr_map[n].label = get_new_label();
                code += node_attr_map[adj[n][3]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += "jmp " + L3 + "\n";
                code += L1 + ": ";
                code += node_attr_map[adj[n][7]].code;
                code += L2 + ": ";
                code += node_attr_map[adj[n][5]].code;
                code += node_attr_map[adj[n][3]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += "jmp " + L3 + "\n";
                code += L3 + ": ";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 3:
                node_attr_map[n].label = get_new_label();
                code = node_attr_map[adj[n][2]].code;
                code += node_attr_map[adj[n][4]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += "jmp " + L3 + "\n";
                code += L1 + ": ";
                code += node_attr_map[adj[n][7]].code;
                code += L2 + ": ";
                code += node_attr_map[adj[n][4]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += "jmp " + L3 + "\n";
                code += L3 + ": ";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 4:
                node_attr_map[n].label = get_new_label();
                code += L1 + ": ";
                code += node_attr_map[adj[n][6]].code;
                code += L2 + ": ";
                code += node_attr_map[adj[n][4]].code;
                code += "jmp " + L1 + "\n";
                code += "jmp " + L3 + "\n";
                code += L3 + ": ";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 5:
                node_attr_map[n].label = get_new_label();
                code += node_attr_map[adj[n][3]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += "jmp " + L3 + "\n";
                code += L1 + ": ";
                code += node_attr_map[adj[n][6]].code;
                code += L2 + ": ";
                code += node_attr_map[adj[n][3]].code;
                code += "popq %rsi\n";
                code += "movq $0, %rax\n";
                code += "cmp %rsi, %rax\n";
                code += "jne " + L1 + "\n";
                code += "jmp " + L3 + "\n";
                code += L3 + ": ";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 6:
                node_attr_map[n].label = get_new_label();
                code = node_attr_map[adj[n][2]].code;
                code += L1 + ": ";
                code += node_attr_map[adj[n][6]].code;
                code += L2 + ": ";
                code += "jmp " + L1 + "\n";
                code += "jmp " + L3 + "\n";
                code += L3 + ": ";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;

            case 7:
                node_attr_map[n].label = get_new_label();
                code += L1 + ": ";
                code += node_attr_map[adj[n][5]].code;
                code += L2 + ": ";
                code += "jmp " + L1 + "\n";
                code += "jmp " + L3 + "\n";
                code += L3 + ": ";
                code += node_attr_map[n].label + ": ";
                node_attr_map[n].code = code;
                while (node_attr_map[n].code.find("c-o-n-t-i-n-u-e") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("c-o-n-t-i-n-u-e"), 15, L2);
                while (node_attr_map[n].code.find("b-r-e-a-k") != string::npos)
                    node_attr_map[n].code = node_attr_map[n].code.replace(node_attr_map[n].code.find("b-r-e-a-k"), 9, L3);
                break;
        }
        return;
    }
    if (name == "ForInit") {
        node_attr_map[n].code = node_attr_map[adj[n][0]].code;
        return;
    }
    if (name == "ForUpdate") {
        node_attr_map[n].label = get_new_label();
        node_attr_map[n].code = node_attr_map[n].label + ": " + node_attr_map[adj[n][0]].code;
        return;
    }
    if (name == "StatementExpressionList") {
        for (auto i : adj[n])
            node_attr_map[n].code = (node_attr_map[i].code + "\n");
        return;
    }

    if (name == "BreakStatement") {
        node_attr_map[n].label = get_new_label();
        node_attr_map[n].code = string("jmp ") + "b-r-e-a-k" + "\n" + node_attr_map[n].label + ": ";
    }
    if (name == "ContinueStatement") {
        node_attr_map[n].label = get_new_label();
        node_attr_map[n].code = string("jmp ") + "c-o-n-t-i-n-u-e" + "\n" + node_attr_map[n].label + ": ";
    }
    if (name == "ReturnStatement") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
            node_attr_map[n].label = get_new_label();
        }
        switch (reducer) {
            case 0:
                node_attr_map[n].code += string("popq %rax\nleave\nret\n") + node_attr_map[n].label + ": ";
                break;
            case 1:
                break;
        }
        return;
    }
    if (name == "ThrowStatement") {
        return;
    }
    if (name == "SynchronizedStatement") {
        return;
    }
    if (name == "TryStatement") {
        return;
    }
    if (name == "Catches") {
        return;
    }
    if (name == "CatchClause") {
        return;
    }

    if (name == "Finally") {
        node_attr_map[n] = node_attr_map[adj[n][1]];
    }

    if (name == "Primary") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
    }
    if (name == "PrimaryNoNewArray") {
        switch (reducer) {
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
                node_attr_map[n].variable = "array";
                break;
        }
        return;
    }
    if (name == "ClassInstanceCreationExpression") {
        node_attr_map[n].variable = get_new_temp();
        string t = get_new_temp();
        // int class_size = get_class_size(node_attr_map[adj[n][1]].type);
        vector<string> class_globals = get_class_globals(node_attr_map[adj[n][1]].type);
        int num_globals = class_globals.size();
        string code = "";
        int loc_offset = 0;
        for (int i = 0; i < num_globals; i++) {
            if (i == 0) {
                int obj_off = -curr_offset - 8;
                code += "movq $" + to_string(obj_off) + ", %r9\n";
                code += "addq %rbp, %r9\n";
            }
            curr_offset += 8;
            code += "pushq %rsi\n";
            obj_form_offset(node_attr_map[adj[n][1]].type, class_globals[i], loc_offset);
            loc_offset -= 8;
        }
        switch (reducer) {
            case 0:
                // node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][1]].code;
                // node_attr_map[n].code += "call allocmem " + to_string(class_size) + "$\n";
                // node_attr_map[n].code += node_attr_map[n].variable + " = RRE \n";
                // node_attr_map[n].code += "move8 " + node_attr_map[n].variable + " -8(%rbp)\n";
                // node_attr_map[n].code += node_attr_map[adj[n][3]].code;

                break;
            case 1:
                // node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][1]].code;
                // node_attr_map[n].code += "call allocmem " + to_string(class_size) + "$\n";
                // node_attr_map[n].code += node_attr_map[n].variable + " = RRE \n";
                // node_attr_map[n].code += "move8 " + node_attr_map[n].variable + " -8(%rbp)\n";
                break;
        }
        if (has_constructor(node_attr_map[adj[n][1]].type)) {
            // call constructor
        }
        code += "pushq %r9\n";
        node_attr_map[n].code = code;
        // node_attr_map[n].code += "call" + node_attr_map[adj[n][0]].variable + " " + node_attr_map[adj[n][1]].type + ".constructor\n";
        // // cout << node_attr_map[n].code;
        return;
    }
    if (name == "ArgumentList") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        switch (reducer) {
            case 0:
                node_attr_map[n].args.push_back(node_attr_map[adj[n][0]].variable);
                break;
            case 1:
                node_attr_map[n].args = node_attr_map[adj[n][0]].args;
                node_attr_map[n].args.push_back(node_attr_map[adj[n][2]].variable);
                break;
        }
        // cout << "\n\n" << node_attr_map[n].code << "\n\n";
        return;
    }
    if (name == "ArrayCreationExpression") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        switch (reducer) {
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

        // // cout << node_attr_map[n].code;
        return;
    }
    if (name == "DimExprs") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        switch (reducer) {
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
    if (name == "DimExpr") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        // node_attr_map[n].code = "popq %rbx\n"
        node_attr_map[n].dims.push_back(node_attr_map[adj[n][1]].variable);

        return;
    }

    if (name == "Dims") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }
        node_attr_map[n].dims = node_attr_map[adj[n][0]].dims;
        node_attr_map[n].dims.push_back("ZERO");
        // // cout << node_attr_map[n].code;
        return;
    }
    if (name == "FieldAccess") {
        for (int i = 0; i < adj[n].size(); i++) {
            node_attr_map[n].code = node_attr_map[n].code + node_attr_map[adj[n][i]].code;
        }

        switch (reducer) {
            case 0:
                node_attr_map[n].variable = "this." + nodes[adj[adj[n][2]][0]];
                break;
            case 1:
                node_attr_map[n].variable = "*" + nodes[adj[adj[n][0]][0]] + "." + node_attr_map[adj[adj[n][1]][0]].variable;
                break;
        }
        // // cout << node_attr_map[n].code;
        return;
    }
    if (name == "MethodInvocation") {
        string code = "";
        for (int i = 0; i < adj[n].size(); i++) {
            code = code + node_attr_map[adj[n][i]].code;
        }
        if(node_attr_map[adj[n][0]].variable != "System.out.println" && (node_attr_map[adj[n][0]].variable).find(".") != string::npos){
            size_t dotIndex = (node_attr_map[adj[n][0]].variable).find(".");
            node_attr_map[adj[n][0]].variable = gimme_class((node_attr_map[adj[n][0]].variable).substr(0,dotIndex), parse_to_ast[n]) + (node_attr_map[adj[n][0]].variable).substr(dotIndex);
        }
        else if(node_attr_map[adj[n][0]].variable != "System.out.println")
            node_attr_map[adj[n][0]].variable = curr_class + "." + node_attr_map[adj[n][0]].variable;
        switch (reducer) {
            case 0:
                if (node_attr_map[adj[n][0]].variable == "System.out.println") {
                    // offset = get_method_offset(node_attr_map[adj[adj[n][2]][0]].variable, parse_to_ast[n]);
                    code += string("popq %rax\n");
                    // offset = -offset;
                    // code += string("pushq %rsi\npushq %rsi\nmovq ") + to_string(offset) + "(%rbp), %rax\n";
                    if(curr_offset % 16 == 0) 
                        code += "pushq %rsi\nmovq %rax, %rsi\nleaq .LC0(%rip), %rdi\nmovq $0, %rax\ncall printf@PLT\npopq %rsi\n";
                    else 
                        code += "pushq %rsi\npushq %rsi\nmovq %rax, %rsi\nleaq .LC0(%rip), %rdi\nmovq $0, %rax\ncall printf@PLT\npopq %rsi\npopq %rsi\n";
                }
                //             	movq	-16(%rbp), %rax
                // movq	%rax, %rsi
                // leaq	.LC0(%rip), %rdi
                // movl	$0, %eax
                // call	printf@PLT
                // offset += get_invoked_method_offset(node_attr_map[adj[n][0]].variable, parse_to_ast[n]);
                break;
            case 1:
                // offset += get_invoked_method_offset(string("this." + adj[adj[n][2]][0]), parse_to_ast[n]);
                break;
            case 2:
                // offset += get_invoked_method_offset(string("super." + adj[adj[n][2]][0]), parse_to_ast[n]);
                break;
            case 4:
                // offset += get_invoked_method_offset(node_attr_map[adj[n][0]].variable, parse_to_ast[n]);
                break;
            case 5:
                // offset += get_invoked_method_offset(string("this." + adj[adj[n][2]][0]), parse_to_ast[n]);
                break;
            case 6:
                // offset += get_invoked_method_offset(string("super." + adj[adj[n][2]][0]), parse_to_ast[n]);
                break;
        }
        vector<string> types, args;
        int args_child;
        switch (reducer) {
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
        if (args_child == -1) {
            switch (reducer) {
                case 3:
                    code += "call " + curr_class + "." + node_attr_map[adj[n][0]].variable + "\n";
                    args_child = -1;
                    break;
                case 4:
                    code += "call " + curr_class + "." + node_attr_map[adj[n][0]].variable + "." + nodes[adj[adj[n][2]][0]] + "\n";
                    args_child = -1;
                    break;
                case 5:
                    code += "call super." + curr_class + "." + nodes[adj[n][2]] + "\n";
                    args_child = -1;
                    break;
            }
            node_attr_map[n].code = code;
            node_attr_map[n].variable = return_reg;
            return;
        }
        // types = get_params(parse_to_ast[n]);
        args = node_attr_map[adj[n][args_child]].args;
        // vector<int> sizes;
        // for (int i = 0; i < types.size(); i++) {
        //     sizes.push_back(get_type_size(types[i]));
        // }
        // int total = 0;
        // for (int i = 0; i < sizes.size(); i++) {
        //     total += sizes[i];
        // }
        int curr = 0;
        for (int i = 0; 2 * i < args.size() - 1; i++) {
            code += string("movq ") + to_string(8 * args.size() - 8 + 8 * i) + "(%rsp), %rsi\n";
            code += string("movq ") + to_string(8 * i) + "(%rsp), %rdi\n";
            code += string("movq %rdi, ") + to_string(8 * args.size() - 8 + 8 * i) + "(%rsp)\n";
            code += string("movq %rsi, ") + to_string(8 * i) + "(%rsp)\n";
        }
        // for (int i = 0; i < args.size(); i++) {
        //     // if (get_method_offset.find(args[i]) == get_method_offset.end()){
        //     //     continue;
        //     // }
        //     code += "movq %rsi, " + to_string(-1 * (  get_method_offset(args[i], parse_to_ast[n]))) + "(%rbp)\n";
        //     code += "pushq %rsi \n";
        //     // curr += sizes[i];
        // }
        switch (reducer) {
            case 0:
                if (node_attr_map[adj[n][0]].variable != "System.out.println") {
                    code += "call " + node_attr_map[adj[n][0]].variable + "\n";
                    args_child = 2;
                }
                break;
            case 1:
                code += "call " + curr_class + "." + node_attr_map[adj[n][0]].variable + "." + nodes[adj[adj[n][2]][0]] + "\n";
                args_child = 4;
                break;
            case 2:
                code += "call super." + curr_class + "." + nodes[adj[n][2]] + "\n";
                args_child = 4;
                break;
        }
        if (node_attr_map[adj[n][0]].variable != "System.out.println") {
            for (int i = 0; i < args.size(); i++) {
                code += "popq %rsi \n";
            }
        }
        code += "pushq %rax\n";
        node_attr_map[n].code = code;
        node_attr_map[n].variable = return_reg;
        // cout << "\n\nPostIncrementexpression" << node_attr_map[n].code << "kahtm\n\n";
        // // cout << node_attr_map[n].code;
        return;
    }
    if (name == "ArrayAccess") {
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
        int offset;
        switch (reducer) {
            case 0:
                sym_ind = var_sym(node_to_sym_tab[parse_to_ast[n]], node_attr_map[adj[n][0]].variable, parse_to_ast[n]);

                offset = stoi(sym_tab[sym_ind][node_attr_map[adj[n][0]].variable]["offset"]);
                node_attr_map[n].code += "movq -" + to_string(offset) + "(%rbp), %rbx\n";

                // node_attr_map[n].code += temp1 + " = " + node_attr_map[adj[n][0]].offset + "*" +
                //                          sym_tab[sym_ind][node_attr_map[adj[n][0]].variable]["dim" + to_string(node_attr_map[adj[n][0]].dim_count)] + "\n";

                // curr_offset -= 8;
                node_attr_map[n].code += "popq %rcx\npushq %rcx\n";
                node_attr_map[n].code += "imulq $8, %rcx\n";
                // node_attr_map[n].code += temp2 + " = " + temp1 + "+" + node_attr_map[adj[n][2]].variable + "\n";
                // +"symtable(" + node_attr_map[adj[n][0]].variable+".dim" + to_string(node_attr_map[adj[n][0]].dim_count)+

                // var_size = get_type_size(sym_tab[sym_ind][node_attr_map[adj[n][0]].variable]["Type"]);
                // node_attr_map[n].code += temp3 + " = " + temp2 + "*" + to_string(var_size) + "\n";

                node_attr_map[n].code += "addq %rcx, %rbx\n";
                node_attr_map[n].code += "pushq %rbx\n";
                // node_attr_map[n].code += temp4 + " = " + temp3 + "+" + node_attr_map[adj[n][0]].variable + "\n";

                node_attr_map[n].arr_ptr = node_attr_map[adj[n][0]].variable;
                node_attr_map[n].dim_count += 1;
                node_attr_map[n].offset = temp2;
                node_attr_map[n].variable = "*" + temp4;
                break;
            case 1:
                sym_ind = var_sym(node_to_sym_tab[parse_to_ast[n]], node_attr_map[adj[n][0]].arr_ptr, parse_to_ast[n]);
                node_attr_map[n].arr_ptr = node_attr_map[adj[n][0]].arr_ptr;

                // curr_offset -= 8;
                node_attr_map[n].code += "popq %rdx\npopq %rbx\npopq %rbx\n";
                offset = stoi(sym_tab[sym_ind][node_attr_map[n].arr_ptr]["dim" + to_string(node_attr_map[adj[n][0]].dim_count)]);
                node_attr_map[n].code += "movq -" + to_string(offset) + "(%rbp), %rcx\n";
                node_attr_map[n].code += "imulq %rcx, %rbx\n";

                // node_attr_map[n].code += temp1 + " = " + node_attr_map[adj[n][0]].offset + "*" +
                //                          sym_tab[sym_ind][node_attr_map[n].arr_ptr]["dim" + to_string(node_attr_map[adj[n][0]].dim_count)] + "\n";
                // +"symtable(" + node_attr_map[adj[n][0]].arr_ptr+".dim" + to_string(node_attr_map[adj[n][0]].dim_count)+
                // node_attr_map[n].code += temp2 + " = " + temp1 + "+" + node_attr_map[adj[n][2]].variable + "\n";

                node_attr_map[n].code += "addq %rdx, %rbx\npushq %rbx\n";

                // var_size = get_type_size(sym_tab[sym_ind][node_attr_map[n].arr_ptr]["Type"]);
                // node_attr_map[n].code += temp3 + " = " + temp2 + "*" + to_string(var_size) + "\n";

                node_attr_map[n].code += "imulq $8, %rbx\n";
                offset = stoi(sym_tab[sym_ind][node_attr_map[adj[n][0]].arr_ptr]["offset"]);
                node_attr_map[n].code += "movq -" + to_string(offset) + "(%rbp), %rcx\n";

                // node_attr_map[n].code += temp4 + " = " + temp3 + "+" + node_attr_map[adj[n][0]].arr_ptr + "\n";
                // node_attr_map[n].arr_ptr = node_attr_map[adj[n][0]].variable;
                node_attr_map[n].code += "addq %rcx, %rbx\npushq %rbx\n";
                node_attr_map[n].dim_count += 1;
                node_attr_map[n].offset = temp2;
                node_attr_map[n].variable = "*" + temp4;
                break;
        }
        return;
    }

    if (name == "PostfixExpression") {
        int offset = 0;
        pair<int, int> offsets;
        switch (reducer) {
            case 0:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                if (node_attr_map[n].variable == "array") {
                    node_attr_map[n].code += "popq %rbx\npopq %rcx\n";
                    node_attr_map[n].code += "movq 0(%rbx), %rcx\npushq %rcx\n";
                }
                break;
            case 1:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                offsets = get_comp_method_offset(node_attr_map[adj[n][0]].variable, parse_to_ast[n]);
                if (offsets.first == -1) {
                    offset = offsets.second;
                    offset = -offset;
                    node_attr_map[n].code += string("movq ") + to_string(offset) + "(%rbp), %rax\n";
                    node_attr_map[n].code += string("pushq %rax\n");
                } else if (offsets.first == -2) {
                    node_attr_map[n].code += string("movq ") + to_string(offsets.second) + "(%r8), %rax\n";
                    node_attr_map[n].code += string("pushq %rax\n");
                } else {
                    offset = offsets.first;
                    offset = -offset;
                    node_attr_map[n].code += string("movq ") + to_string(offset) + "(%rbp), %r10\n";
                    node_attr_map[n].code += string("movq ") + to_string(offsets.second) + "(%r10), %rax\n";
                    node_attr_map[n].code += string("pushq %rax\n");
                }
                break;
            case 2:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
            case 3:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
        }
        // // cout << node_attr_map[n].code;
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you in postfix\n";
        return;
    }
    if (name == "PostIncrementExpression") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        int offset = get_method_offset(node_attr_map[adj[n][0]].variable, parse_to_ast[n]);
        offset = -offset;
        node_attr_map[n].code += string("popq %rax\npushq %rax\naddq $1, %rax\n");
        node_attr_map[n].code += string("movq %rax,") + to_string(offset) + "(%rbp)\n";

        // // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }
    if (name == "PostDecrementExpression") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        int offset = get_method_offset(node_attr_map[adj[n][0]].variable, parse_to_ast[n]);
        offset = -offset;
        node_attr_map[n].code += string("popq %rax\npushq %rax\nsubq $1, %rax\n");
        node_attr_map[n].code += string("movq %rax,") + to_string(offset) + "(%rbp)\n";
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }
    if (name == "UnaryExpression") {
        switch (reducer) {
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
                node_attr_map[n].code += string("popq %rax\nimulq $-1, %rax\npushq %rax\n");
                break;
            case 4:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
        }

        // if(node_attr_map[n].label ==  "L3")
        // // cout << node_attr_map[n].code;
        // // cout << "found you in unary\n";
        return;
    }
    if (name == "PreIncrementExpression") {
        node_attr_map[n] = node_attr_map[adj[n][1]];
        int offset = get_method_offset(node_attr_map[adj[n][1]].variable, parse_to_ast[n]);
        offset = -offset;
        node_attr_map[n].code += string("popq %rax\naddq $1, %rax\npushq %rax\n");
        node_attr_map[n].code += string("movq %rax,") + to_string(offset) + "(%rbp)\n";
        // // cout << "PostIncrementexpression" << node_attr_map[n].code << "kahtm\n";
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }
    if (name == "PreDecrementExpression") {
        node_attr_map[n] = node_attr_map[adj[n][1]];
        int offset = get_method_offset(node_attr_map[adj[n][1]].variable, parse_to_ast[n]);
        offset = -offset;
        node_attr_map[n].code += string("popq %rax\nsubq $1, %rax\npushq %rax\n");
        node_attr_map[n].code += string("movq %rax,") + to_string(offset) + "(%rbp)\n";

        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }
    if (name == "UnaryExpressionNotPlusMinus") {
        switch (reducer) {
            case 0:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
            case 1:
                node_attr_map[n].code = node_attr_map[adj[n][1]].code;
                node_attr_map[n].code += string("popq %rax\nimulq $-1,%rax\npushq %rax\n");
                break;
            case 2:
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][1]].code;
                node_attr_map[n].code += string("popq %rax\nnotq %rax\npushq %rax\n");
                break;
            case 3:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
        }
        // // cout << node_attr_map[n].code;
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }
    if (name == "CastExpression") {
        // unimplemented
        // // cout << node_attr_map[n].code;
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        node_attr_map[n] = node_attr_map[adj[n][0]];
        return;
    }
    if (name == "MultiplicativeExpression") {
        switch (reducer) {
            case 0:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
            case 1:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += string("popq %rbx\npopq %rax\nimulq %rbx, %rax\npushq %rax\n");
                break;
            case 2:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += "popq %rbx\npopq %rax\ncltd\nidivq %rbx\npushq %rax\n";
                break;
            case 3:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += "popq %rbx\npopq %rax\ncltd\nidiv %rbx\npushq %rdx\n";
                break;
        }
        // cout << node_attr_map[n].code;
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }

    if (name == "AdditiveExpression") {
        switch (reducer) {
            case 0:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
            case 1:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += "popq %rbx\npopq %rax\naddq %rbx,%rax\npushq %rax\n";
                break;
            case 2:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += "popq %rbx\npopq %rax\nsubq %rbx,%rax\npushq %rax\n";
                break;
        }
        // cout << node_attr_map[n].code << "\n\n";
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }

    if (name == "ShiftExpression") {
        switch (reducer) {
            case 0:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
            case 1:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += "popq %rbx\npopq %rax\nmovq %rbx,%rcx\nsalq %cl, %rax\npushq %rax\n";
                break;
            case 2:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += "popq %rbx\npopq %rax\nmovq %rbx,%rcx\nsarq %cl,%rax\npushq %rax\n";
                break;
            case 3:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += "popq %rbx\npopq %rax\nmovq %rbx,%rcx\nshrq %cl,%rax\npushq %rax\n";
                break;
        }
        // // cout << node_attr_map[n].code;
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }
    if (name == "RelationalExpression") {
        string label1, label2;
        switch (reducer) {
            case 0:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
            case 1:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                label1 = get_new_label();
                label2 = get_new_label();
                node_attr_map[n].code += string("popq %rbx\npopq %rax\ncmp %rax,%rbx\njg ") + label1 + "\n";
                node_attr_map[n].code += string("movq $0, %rax\npushq %rax\njmp ") + label2 + "\n";
                node_attr_map[n].code += label1 + ":\n";
                node_attr_map[n].code += string("movq $-1, %rax\npushq %rax\n") + label2 + ":\n";
                break;
            case 2:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                label1 = get_new_label();
                label2 = get_new_label();
                node_attr_map[n].code += string("popq %rbx\npopq %rax\ncmp %rbx,%rax\njg ") + label1 + "\n";
                node_attr_map[n].code += string("movq $0, %rax\npushq %rax\njmp ") + label2 + "\n";
                node_attr_map[n].code += label1 + ":\n";
                node_attr_map[n].code += string("movq $-1, %rax\npushq %rax\n") + label2 + ":\n";
                break;
            case 3:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                label1 = get_new_label();
                label2 = get_new_label();
                node_attr_map[n].code += string("popq %rbx\npopq %rax\ncmp %rax,%rbx\njge ") + label1 + "\n";
                node_attr_map[n].code += string("movq $0, %rax\npushq %rax\njmp ") + label2 + "\n";
                node_attr_map[n].code += label1 + ":\n";
                node_attr_map[n].code += string("movq $-1, %rax\npushq %rax\n") + label2 + ":\n";
                break;
            case 4:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                label1 = get_new_label();
                label2 = get_new_label();
                node_attr_map[n].code += string("popq %rbx\npopq %rax\ncmp %rbx,%rax\njge ") + label1 + "\n";
                node_attr_map[n].code += string("movq $0, %rax\npushq %rax\njmp ") + label2 + "\n";
                node_attr_map[n].code += label1 + ":\n";
                node_attr_map[n].code += string("movq $-1, %rax\npushq %rax\n") + label2 + ":\n";
                break;
            case 5:
                // instanceof unimplemented
                break;
        }
        node_attr_map[n].type = "boolean";
        node_attr_map[n].size = 1;
        // // cout << node_attr_map[n].code;
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }
    if (name == "EqualityExpression") {
        string label1, label2;
        switch (reducer) {
            case 0:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
            case 1:

                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                label1 = get_new_label();
                label2 = get_new_label();
                node_attr_map[n].code += string("popq %rbx\npopq %rax\ncmp %rax,%rbx\nje ") + label1 + "\n";
                node_attr_map[n].code += string("movq $0, %rax\npushq %rax\njmp ") + label2 + "\n";
                node_attr_map[n].code += label1 + ":\n";
                node_attr_map[n].code += string("movq $-1, %rax\npushq %rax\n") + label2 + ":\n";
                break;
            case 2:
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                label1 = get_new_label();
                label2 = get_new_label();
                node_attr_map[n].code += string("popq %rbx\npopq %rax\ncmp %rax,%rbx\njne ") + label1 + "\n";
                node_attr_map[n].code += string("movq $0, %rax\npushq %rax\njmp ") + label2 + "\n";
                node_attr_map[n].code += label1 + ":\n";
                node_attr_map[n].code += string("movq $-1, %rax\npushq %rax\n") + label2 + ":\n";
                break;
        }
        node_attr_map[n].type = "boolean";
        node_attr_map[n].size = 1;
        // // cout << node_attr_map[n].code;
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }
    if (name == "AndExpression") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        switch (reducer) {
            case 0:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
            case 1:
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += string("popq %rbx\npopq %rax\nandq %rax,%rbx\npushq %rax\n");
                break;
        }
        // // cout << node_attr_map[n].code;
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }

    if (name == "ExclusiveOrExpression") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        switch (reducer) {
            case 0:
                break;
            case 1:
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += string("popq %rbx\npopq %rax\nxorq %rbx,%rax\npushq %rax\n");
                break;
        }
        // // cout << node_attr_map[n].code;
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }
    if (name == "InclusiveOrExpression") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        switch (reducer) {
            case 0:
                break;
            case 1:
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += string("popq %rbx\npopq %rax\norq %rbx,%rax\npushq %rax\n");
                break;
        }
        // // cout << node_attr_map[n].code;
        // if(node_attr_map[n].label ==  "L3")
        // // cout << "found you\n";
        return;
    }

    if (name == "ConditionalAndExpression") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        switch (reducer) {
            case 0:
                break;
            case 1:
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += "popq %rbx\npopq %rax\nandq %rbx,%rax\npushq %rax\n";
                break;
        }
        return;
    }
    if (name == "ConditionalOrExpression") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        switch (reducer) {
            case 0:
                break;
            case 1:
                node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;
                node_attr_map[n].code += "popq %rbx\npopq %rax\norq %rbx,%rax\npushq %rax\n";
                break;
        }
        return;
    }
    if (name == "ConditionalExpression") {
        switch (reducer) {
            case 0:
                node_attr_map[n] = node_attr_map[adj[n][0]];
                break;
            case 1:
                string code;

                string true_label = get_new_label();
                string false_label = get_new_label();

                code += node_attr_map[adj[n][0]].code;
                code += "popq %rax\n";
                code += "cmp %rax, 0\n";
                code += "jne " + true_label + "\n";
                code += node_attr_map[adj[n][4]].code;
                code += "jmp " + false_label + "\n";
                code += true_label + ": " + node_attr_map[adj[n][2]].code;
                code += false_label + " : \n";
                node_attr_map[n].code = code;

                break;
        }
        return;
    }

    if (name == "AssignmentExpression") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        return;
    }

    if (name == "Assignment") {
        node_attr_map[n].code = node_attr_map[adj[n][0]].code + node_attr_map[adj[n][2]].code;

        if (node_attr_map[adj[n][1]].variable == "ASSIGN(=)") {
            node_attr_map[n].code += "popq %rax\n";
            node_attr_map[n].code += string("movq %rax, ") + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rax\n";
        } else if (node_attr_map[adj[n][1]].variable == "MULTIPLY_ASSIGN(*=)") {
            node_attr_map[n].code += "popq %rax\n";
            node_attr_map[n].code += "movq %rax, %rsi\n";
            node_attr_map[n].code += "movq " + node_attr_map[adj[n][0]].variable + ", %rax\n";
            node_attr_map[n].code += "imulq %rsi, %rax\n";
            node_attr_map[n].code += "movq %rax, " + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rax\n";
        } else if (node_attr_map[adj[n][1]].variable == "DIVIDE_ASSIGN(/=)") {
            node_attr_map[n].code += "popq %rbx\n";
            node_attr_map[n].code += "movq " + node_attr_map[adj[n][0]].variable + ", %rax\n";
            node_attr_map[n].code += "cltd\nidivq %rbx\n";
            node_attr_map[n].code += "movq %rax, " + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rax\n";
        } else if (node_attr_map[adj[n][1]].variable == "MODULO_ASSIGN(%=)") {
            node_attr_map[n].code += "popq %rbx\n";
            node_attr_map[n].code += "movq " + node_attr_map[adj[n][0]].variable + ", %rax\n";
            node_attr_map[n].code += "cltd\nidivq %rbx\n";
            node_attr_map[n].code += "movq %rdx, " + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rdx\n";
        } else if (node_attr_map[adj[n][1]].variable == "PLUS_ASSIGN(+=)") {
            node_attr_map[n].code += "popq %rbx\n";
            node_attr_map[n].code += "movq " + node_attr_map[adj[n][0]].variable + ", %rax\n";
            node_attr_map[n].code += "addq %rbx, %rax\n";
            node_attr_map[n].code += "movq %rax, " + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rax\n";
        } else if (node_attr_map[adj[n][1]].variable == "MINUS_ASSIGN(-=)") {
            node_attr_map[n].code += "popq %rbx\n";
            node_attr_map[n].code += "movq " + node_attr_map[adj[n][0]].variable + ", %rax\n";
            node_attr_map[n].code += "subq %rbx, %rax\n";
            node_attr_map[n].code += "movq %rax, " + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rax\n";
        } else if (node_attr_map[adj[n][1]].variable == "LEFT_SHIFT_ASSIGN(<<=)") {
            node_attr_map[n].code += "popq %rcx\n";
            node_attr_map[n].code += "movq " + node_attr_map[adj[n][0]].variable + ", %rax\n";
            node_attr_map[n].code += "salq %cl, %rax\n";
            node_attr_map[n].code += "movq %rax, " + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rax\n";
        } else if (node_attr_map[adj[n][1]].variable == "RIGHT_SHIFT_ASSIGN(>>=)") {
            node_attr_map[n].code += "popq %rcx\n";
            node_attr_map[n].code += "movq " + node_attr_map[adj[n][0]].variable + ", %rax\n";
            node_attr_map[n].code += "sarq %cl, %rax\n";
            node_attr_map[n].code += "movq %rax, " + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rax\n";
        } else if (node_attr_map[adj[n][1]].variable == "UNSIGNED_RIGHT_SHIFT_ASSIGN(>>>=)") {
            node_attr_map[n].code += "popq %rcx\n";
            node_attr_map[n].code += "movq " + node_attr_map[adj[n][0]].variable + ", %rax\n";
            node_attr_map[n].code += "shrq %cl, %rax\n";
            node_attr_map[n].code += "movq %rax, " + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rax\n";
        } else if (node_attr_map[adj[n][1]].variable == "AND_ASSIGN(&=)") {
            node_attr_map[n].code += "popq %rbx\n";
            node_attr_map[n].code += "movq " + node_attr_map[adj[n][0]].variable + ", %rax\n";
            node_attr_map[n].code += "andq %rbx, %rax\n";
            node_attr_map[n].code += "movq %rax, " + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rax\n";
        } else if (node_attr_map[adj[n][1]].variable == "XOR_ASSIGN(^=)") {
            node_attr_map[n].code += "popq %rbx\n";
            node_attr_map[n].code += "movq " + node_attr_map[adj[n][0]].variable + ", %rax\n";
            node_attr_map[n].code += "xorq %rbx, %rax\n";
            node_attr_map[n].code += "movq %rax, " + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rax\n";
        } else if (node_attr_map[adj[n][1]].variable == "OR_ASSIGN(|=)") {
            node_attr_map[n].code += "popq %rbx\n";
            node_attr_map[n].code += "movq " + node_attr_map[adj[n][0]].variable + ", %rax\n";
            node_attr_map[n].code += "orq %rbx, %rax\n";
            node_attr_map[n].code += "movq %rax, " + node_attr_map[adj[n][0]].variable + "\n";
            node_attr_map[n].code += "pushq %rax\n";
        }

        // cout << "\n\n"<< node_attr_map[n].code << "\n\n" ;
        return;
    }

    if (name == "LeftHandSide") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        pair<int, int> offsets;
        int offset;
        switch (reducer) {
            case 0:
                offsets = get_comp_method_offset(node_attr_map[n].variable, parse_to_ast[n]);
                offset = 0;
                if (offsets.first == -1) {
                    int offset = offsets.second;
                    offset = offset * -1;
                    node_attr_map[n].variable = string("") + to_string(offset) + "(%rbp)";
                } else if (offsets.first == -2) {
                    node_attr_map[n].variable = string("") + to_string(offsets.second) + "(%r8)";
                } else {
                    offset = -offsets.first;
                    node_attr_map[n].code = "movq " + to_string(offset) + "(%rbp), %r10\n";
                    node_attr_map[n].variable = string("") + to_string(offsets.second) + "(%r10)";
                }
                break;
            case 1:
                break;
            case 2:
                node_attr_map[n].code += "popq %r10\npopq %rcx\n";
                node_attr_map[n].variable = string("") + "0(%r10)";
                break;
        }
        return;
    }

    if (name == "AssignmentOperator") {
        node_attr_map[n].variable = nodes[adj[n][0]];
        // cout << "\n\n" << node_attr_map[n].variable << "\n\n";
        return;
    }

    if (name == "Expression") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        return;
    }

    if (name == "ConstantExpression") {
        node_attr_map[n] = node_attr_map[adj[n][0]];
        return;
    }
}

void post_order(int node) {
    if(nodes[node] == "ClassDeclaration"){
        int reducer = node_prod[node];
        switch(reducer){
            case 0:
                curr_class = nodes[adj[adj[node][2]][0]];
                break;
            case 1:
                curr_class = nodes[adj[adj[node][1]][0]];
                break;
            case 2:
                curr_class = nodes[adj[adj[node][2]][0]];
                break;
            case 3:
                curr_class = nodes[adj[adj[node][2]][0]];
                break;
            case 4:
                curr_class = nodes[adj[adj[node][1]][0]];
                break;
            case 5:
                curr_class = nodes[adj[adj[node][1]][0]];
                break;
            case 6:
                curr_class = nodes[adj[adj[node][2]][0]];
                break;
            case 7:
                curr_class = nodes[adj[adj[node][1]][0]];
                break;
        }
    }
    for (int i = 0; i < adj[node].size(); i++) {
        post_order(adj[node][i]);
    }
    postorder_x86(node);
}