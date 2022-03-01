%****************************In the Name of God****************************
% ValueType class is an enumeration that contains types of values is used
% in DBN.

% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our web page.
%
% The programs and documents are distributed without any warranty, express
% or implied.  As the programs were written for research purposes only,
% they have not been tested to the degree that would be advisable in any
% important application.  All use of these programs is entirely at the
% user's own risk.

% CONTRIBUTORS
%	Created by:
%   	Mohammad Ali Keyvanrad (http://ceit.aut.ac.ir/~keyvanrad)
%   	12/2015
%           LIMP(Laboratory for Intelligent Multimedia Processing),
%           AUT(Amirkabir University of Technology), Tehran, Iran
%**************************************************************************
%ValueType class or enumeration
classdef ValueType

    % binary: Units are 0 or 1
    % probability: Units are in [0,1]
    % gaussian: Units are in [-Inf,+Inf] with zero mean and unit variance
    properties (Constant)
        binary = 1;
        probability = 2;
        gaussian = 3;
    end

end
