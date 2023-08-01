#include<bits/stdc++.h>
using namespace std;

#ifndef UTILS
#define UTILS

extern int temp_count;
extern int label_count;

string get_new_temp(){
     string temp = "t";
     temp += to_string(temp_count);
     temp_count++;
     return temp;
}

string get_new_label(){
     string label = "L";
     label += to_string(label_count);
     label_count++;
     return label;
}

class node_attr {
public:
    string code;
    string variable;
    string label;
    string type;
    string val;
    string arr_ptr;
    int true_goto, false_goto,size;
    string offset;
    vector<string> dims;
    int dim_count;
    int arg_count;
    int sp_offset;
    vector<string> args;
    vector<int> sizes;

    node_attr() {
        this->code = "";
        this->variable = "";
        this->true_goto = -1;
        this->false_goto = -1;
        this->size = -1;
        this->label = "";
        this->type = "";
        this->val = "";
        this->dim_count = 0;
        this->dims = vector<string>();
        this->offset = "ZERO";
        this->arr_ptr = "";
        this->arg_count = 0;
        this->sp_offset = 0;
        this->args = vector<string>();
        this->sizes = vector<int>();
    }
}; 

#endif
