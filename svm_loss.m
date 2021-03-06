function [loss, dscores] = svm_loss(scores, y)
%SVM_LOSS function
%
% Inputs have dimension D, there are C classes, and operate on minibatches
% of N examples.
%
% Inputs:
% - scores: [C, N]
% - y: [1, N]   make sure y is 1 based
%
% Returns a tuple of:
% - loss: single number of the svm loss
% - dscores: gradient with respect to scores

N = size(scores, 2);   % N samples

% Index trick:
% To get the score of the target label, we first convert subscript to
% index, and get the element by index.
target_ind = sub2ind(size(scores), y, 1:N);
target_scores = scores(target_ind);     % [N, 1]

% compute margins
margins = bsxfun(@minus, scores, target_scores) + 1;    % [C, N]

% hinge loss
hinge_loss = max(0, margins);    

% set the loss of target label to 0
hinge_loss(target_ind) = 0;

% svm_loss = margin_sum / N, no regularization yet
loss = sum(sum(hinge_loss)) / N;

% dscores = dloss/dscores
dscores = zeros(size(scores),'like',scores);
dscores(margins>0) = 1;
dscores(target_ind) = dscores(target_ind) - sum(margins>0);
dscores = dscores / single(N);

% scores = W * X + 0.5*reg*W^2
% => dW = dscores * X + reg*W
% dW = dscores*X' + reg*W;


