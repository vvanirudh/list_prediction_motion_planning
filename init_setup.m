%% Add required paths 
setenv('DATASET', '/home/aeroscout/data/list_prediction_dataset/');


%% Add path to dataset
old_folder = cd('matlab_environment_generation');
run init_setup;
cd(old_folder);

old_folder = cd('matlab_cost_functions');
run init_setup;
cd(old_folder);

old_folder = cd('chomp');
run init_setup;
cd(old_folder);

old_folder = cd('ranking');
run init_setup;
cd(old_folder);

old_folder = cd('regression');
run init_setup;
cd(old_folder);

old_folder = cd('clustering');
run init_setup;
cd(old_folder);

old_folder = cd('cs_classification');
run init_setup;
cd(old_folder);

old_folder = cd('conseqopt');
run init_setup;
cd(old_folder);

old_folder = cd('scp');
run init_setup;
cd(old_folder);

old_folder = cd('seqopt');
run init_setup;
cd(old_folder);

addpath(genpath(strcat(pwd,'/feature_extraction')));
addpath(genpath(strcat(pwd,'/utils')));
