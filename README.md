# README #

This repository is an implementation in MATLAB of the work described 'List
Prediction Applied to Motion Planning',
https://www.ri.cmu.edu/pub_files/2016/5/main1.pdf

## Setup ##

The datasets are too large for the repository. Download them from
TODO

A global variable DATASET, needs to be set to the path of the datasets, for example
>> setenv('DATASET', 'my/project/path/list_prediction_dataset/');

It is convenient to set this command via a script.

Assuming you are at the top level
(e.g. my/project/path/list_prediction_motion_planning/), before using the code,
run the top level initial setup script 
>> init_setup

## Example ##

We describe how to run list prediction with hinge loss on the 2d trajectory
optimization dataset. List prediction loss is implemented under
list_prediction_motion_planning/cs_classification.

Head to cs_classification/examples/. List prediction is run via the script 
>> conseqopt_cs_classification

The variable 'set' denotes the dataset to run list prediction on. Specify 'set =
1' to use the 2d trajectory optimization dataset. 

'B' denotes the budget length, for example 'B = 3'.

'surrogate_loss' can be set to square or hinge, as described in the paper. Using
the square loss leads to a form similar to weighted regression, while the hinge
loss leads to a form similar to an SVM.

The 'features_choice_struct' can be ignored for a first trial. Library contexts
can be appended to the environment contexts; features can be appended down
levels; either the difference or average of features can be appended. 

'lambda' is the regularization constant for the objective function, separately
specified for each dataset.

During training, the fraction of training environments correctly classified at
each level in the list is printed.

The resulting list of predictors can be run on validation or test data. Comment
out the section of interest. During testing, the loss at each level in the list
is printed, as well as the overall evaluation error.

## File descriptions ##


Under list_prediction_motion_planning/,

analysis/ is helper code to visualize predicted trajectories on the 2d
optimization dataset

box_qp/ is an implementation of box-constrained quadratic programming

chomp/ is the trajectory optimizer used in the 2d optimization dataset

conseqopt/ contains helper utility functions to manage features, evaluate losses
etc.

cs_classification/ is the implementation of loss-sensitive classification

dataset_creation/, feature_extraction/, matlab_cost_function/,
matlab_environment_generation/ is code to generate the 2d optimization dataset

regression/ is an alternate implementation of loss sensitive classification with
hinge loss, rewritten as weighted linear regression

scp/ is an implementation of sequential contextual prediction

seqopt/ is an implementation of sequential prediction, where the features are
not taken into account and a static list is predicted

utils/ contains various helper functions

### Contacts ###

Sanjiban Choudhury
http://www.ri.cmu.edu/person.html?person_id=2740

Abhijeet Tallavajhula
http://www.ri.cmu.edu/person.html?person_id=3155