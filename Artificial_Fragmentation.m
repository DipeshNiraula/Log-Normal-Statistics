%this program uses the tree class developed by Jean-Yves Tinevez 
%please download the tree class from the following link prior to running
%this file
%https://www.mathworks.com/matlabcentral/fileexchange/35623-tree-data-structure-as-a-matlab-class
format shortg
Rock_size=table;%creates a table to keep record of total fragments
Total_Experiment=100;%defines the no of unit size rock to be fragmented
Total_fragments = zeros(Total_Experiment,1);%creates a coloumn vector to record number of fragments per experiment
ini_size=1;%inital size defined to define critical size as a fraction 
critical_size=0.01*ini_size;% critical size defined to be 0.01 times the initial size
for Experiment=1:Total_Experiment %Experiment begins
    mother_size=ini_size;% setting inital size of the Initial List
    Experiment %left a semi-colon intentionally for tracking the progess
    t = tree(mother_size);%create a tree structure with mother_size as the root node
    Mother_node=1;%%counts mother node necessary for counting leaf nodes
    total_Node=1;%counts total node necessary for counting leaf nodes
    fragment_size_leaf_node=[];%initializing a zero matrix for the leaf nodes used as the Final List
    sum=0;%initialing sum for the law of conservation of mass/volume    
    while 1 %fragmentation begins
        if mother_size > critical_size
            while 1
                size = mother_size*rand; %children volume generation formula
                sum = sum+size; %vol_sum varifies the conserved quantity
                total_Node=total_Node+1;%counts the number of rocks fragmented
                if sum<=mother_size%checks if the summation of the childern size is smaller than their mother's
                    t=t.addnode(Mother_node, size);% assign fragment size to its respective parent node in a tree structure                  
                else
                    size = mother_size-(sum-size);%when the summation of the childern size exceeds their mother's; last fragment
                    t=t.addnode(Mother_node, size);% assign fragment size to its respective parent node in a tree structure
                    Mother_node=Mother_node+1;%for moving to the next rock in the List 
                    mother_size=t.get(Mother_node);% assign the size of the next rock for fragmentation
                    sum=0;%refersh sum value for the law of conservation of mass/volume
                   
                    break
                 end
            end
        %checking if the rock is below the critical size     
        elseif mother_size <= critical_size && Mother_node < total_Node
            fragment_size_leaf_node = [fragment_size_leaf_node; t.get(Mother_node)];% assigns smaller fragments to the Final List
            Mother_node=Mother_node+1;%for moving to the next rock in the List
            mother_size=t.get(Mother_node);% assign the size of the next rock for fragmentation
            
        elseif Mother_node >= total_Node %this makes sure that the all the rocks are smaller than critical size, end of an experiment
            break
        end
    end
    fragment_size_leaf_node_table=table(fragment_size_leaf_node);%creating the Final List by enlisting only the leaf node fragments
    Total_fragments(Experiment,1)=length(fragment_size_leaf_node);%recording number of fragments from the Final List per Experiment
    Rock_size=vertcat(Rock_size,fragment_size_leaf_node_table);%combining the Final List from subsequent Experiments 
end
save('Artificial_fragmentation.mat','Rock_size','Total_fragments')% save the final List of fragments and the number of fragments from each experiment as a MATLAB variable for Data Analysis
disp(t.tostring)% display the tree-structure of the last Experiment
figure
t.plot;
%plot probability density of the rock size
bins = 100;
rock_size =Rock_size.fragment_size_leaf_node;
figure
hist1=histogram(rock_size,bins,'Normalization','probability');
xlabel('rock size')
ylabel('Probability Density')
