%this program uses the tree class developed by Jean-Yves Tinevez 
%https://www.mathworks.com/matlabcentral/fileexchange/35623-tree-data-structure-as-a-matlab-class
%please download the tree class from the following link prior to running
%this file
format shortg
Rock_size=table;%creates a table to keep record of total fragments
Total_Experiment=100;%defines the no of unit size rock to be fragmented
Total_fragments = zeros(Total_Experiment,1);%creates a coloumn vector to record number of fragments per experiment
for Experiment=1:Total_Experiment %Experiment begins
    
    mother_size=1;% setting unit size of the initial List
    Experiment %left a semi-colon intentionally for tracking the progess
    t = tree(mother_size);%create a tree structure with mother_size as the root node
    Round=6;%total round of fragmentation
    frag_size_log=zeros();%initialize fragment list
    counter=1;%counter for the round
    sum=0;%initialing sum for the law of conservation of mass/volume
    
    record=zeros(10,1);% create a record for the parent-children node number necessary for defining Round
    start=2; %initialing a variable necessary for defining Round
    mother_node=1;%counts mother node necessary for defining Round and counting leaf nodes
    total_Node=1;%counts total node necessary for defining Round and counting leaf nodes
    
    while counter <= Round  %begin fragmentation
        while 1
            size = mother_size*rand; %children size generation formula
            sum = sum+size; %vol_sum varifies the conserved quantity
            total_Node=total_Node+1;%counts the number of rocks fragmented    
            if sum<=mother_size %checks if the summation of the childern size is smaller than their mother's
                t=t.addnode(mother_node, size); % assign fragment size to its respective parent node in a tree structure
                record(total_Node,1) = total_Node; %update record necessary to define Round
                frag_size_log(total_Node,1)=size; %update fragment list
            else
                size = mother_size-(sum-size); %when the summation of the childern size exceeds their mother's; last fragment
                t=t.addnode(mother_node, size);% assign fragment size to its respective parent node in a tree structure
                frag_size_log(total_Node,1)=size; %update fragment list
                record(total_Node) = total_Node; %update record necessary to define Round
                mother_node=mother_node+1; %for moving to the next rock in the List          
                mother_size=t.get(mother_node);% assign the size of the next rock for fragmentation
                sum=0; %refersh sum value for the law of conservation of mass/volume
                %checking the completion of a round
                for i = start: total_Node % total node is the number of nodes in the tree
                    childern_node = record(i,1);% assigns childern node from the record
                    %the ordering of the nodes start from the first to the last fragment on a List and then goes to the next List formed by the childrens
                    %by exploiting this trend we can define a Round
                    %Consider Round 2 in the tree diagram of Fig. 1 of the description
                    %when the 0.05 mother fragment is done with fragmentation the
                    %next mother fragment is the 0.036 fragment which is
                    %also the children fragment of the fragment 0.21 which
                    %denotes the completion of a Round
                    if mother_node==childern_node %if the mother node index = children node index that means one fragmentation round is complete
                        true = 1;
                        j = total_Node;
                        record(i:total_Node,1)=0;%set the record to zero for all the repeated mother nodes for avoiding double counting for the subsequent Rounds
                        start = total_Node+1;% reset the variable to avoid comparing with zeros of the record
                        break
                    end   
                end
            end
            if true ==1%when a repeated parent-children is found the program jumps to next round of stomping event
                true=0;
                break
            end
            
        end
        counter=counter+1;%update the Round Number
    end
    Total_fragments(Experiment,1)=total_Node-mother_node+1;%formula to calculate leaf nodes which is also the number of fragments in the final list
    counter_b=mother_node;
    Fragment_size_leaf_node=frag_size_log(counter_b:total_Node,1);%creating the final list by enlisting onlt the leaf node fragments
    Rock_size_leaf_node_table=table(Fragment_size_leaf_node);% creating a table so as to include all the Experiments
    Rock_size=vertcat(Rock_size,Rock_size_leaf_node_table);%combining the final List from subsequent Experiments 
end
save('Natural_fragmentation.mat','Rock_size','Total_fragments')% save the final List of fragments and the number of fragments from each experiment as a MATLAB variable for Data Analysis
disp(t.tostring)% display the tree-structure of the last Experiment
figure
t.plot;
%end
%plot probability density of the rock size
bins = 100;
ln_rock_size =log(Rock_size.Fragment_size_leaf_node);
figure
hist=histogram(ln_rock_size,bins,'Normalization','probability');
xlabel('ln(rock size)')
ylabel('Probability Density')
