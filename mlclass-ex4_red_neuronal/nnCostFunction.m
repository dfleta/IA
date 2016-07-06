function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

% matriz Y derivada de y (clases K a 1 y 0)
% Y = zeros(size(m,num_labels));

% Añadir unos a la matriz X
 X = [ones(m, 1) X];
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%================= h(x)================

% h(x) es = a las unidades a3 de la capa de salida

a2 = sigmoid( X * Theta1' );

a2 = [ones(m, 1) a2];

a3 = sigmoid( a2 * Theta2' );

% a3 o h(x) es una matriz de m filas, k (num_labels) columnas

%======================================

% convertir las etiquetas del vector de salida "y" en números k = 1 .. 10
% es convertir el vector "y" en una matriz con K columnas (10) donde % cada columna es un vector de 1 y 0, obtenido del array lógico que 
% devuelve y == i, donde i=1:10(num_lables)
% obtenemos una matriz con m filas, k (num_labels) columnas

for i=1:num_labels
	Y(:,i) = (y == i)
endfor

% con las predicciones h(x) NO hay que hacer la misma jugada

% funcion coste (sin regularizar) vectorizada para la red neuronal
% El sumatorio en K se obtiene:
% 1. Multiplicano elemento a elemento, i.e., columna a columna, 
% las matrices Y, a3 (=h(x) ). i.e., multiplicar la función "y" de la clase  
% K (= columna K matriz Y) por la prediccion h(x) de la clase k (= 
% columna k de a3)
% se obtiene una matriz m*k  => ahora realizar el sumatorio de cada 
% columna para obtener un vector de k columnas (y 1 fila)
% para finalmente realizar el sumatorio de ese vector y obtener un 
% escalar

%------- funcion J, cálculos término sin regularizar --------

matriz =  (- Y) .* log(a3)  - ( 1 - Y ) .* log(1 - a3) ;

for i=1:num_labels
	sumatorioK(i) = sum(matriz(:,i))
endfor

%------- funcion J, cálculos término regularizacion--------

sumatorioKTheta1 = sum(Theta1(:,2:end).^2);

sumatorioKTheta2 = sum(Theta2(:,2:end).^2);

%-------- funcion J regularizada ------------

J = (1/m) * sum(sumatorioK) + (lambda/(2*m))* ...
	( sum(sumatorioKTheta1) + sum(sumatorioKTheta2));


% -------- gradiente ------------

% X es a1 y ya contiene la columna extra, a2 ya contiene la columna extra (theta0)
% a3 es h(x) y no requiere término theta0

% cálculo del gradiente en la capa 3 (salida) para cada unidad k

delta_3 = a3 - Y;

% gradiente capa oculta (capa 2)

delta_2 =  delta_3 * Theta2(:,2:end) .* sigmoidGradient(X * Theta1');

% DELTAs son los gradientes para cada característica de cada muestra
% en cada unidad, por tanto, esas matrices deben tener = dimensiones
% que las matrices theta1 y theta2, pues:
% theta1 = theta1 - gradte1(=DELTA1)
% theta2 = theta2 - gradte2(=DELTA2)

Delta_1 = delta_2' * X;

Delta_2 = delta_3' * a2;

% regularizacion
% el término j=0 BIAS (la primera unidad de la capa 1, entrada) está en la primera 
% columna de Theta1
Theta1_grad(:,1) = (1/m) * Delta_1(:,1);
Theta1_grad(:,2:end) = (1/m) * (Delta_1(:,2:end) + lambda*Theta1(:,2:end));

% el término j=0 (la primera unidad de la capa 2, oculta) está en la primera fila columna de Theta2
Theta2_grad(:,1) = (1/m) * Delta_2(:,1);
Theta2_grad(:,2:end) = (1/m) * (Delta_2(:,2:end) + lambda*Theta2(:,2:end));

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
