load("mnist.mat");

for d=0:9
   digits = digits_train(:, :, labels_train==d);
   digits = reshape(im2double(digits), [784 size(digits, 3)]);
   
   mean_vector = sum(digits, 2)/size(digits, 2);
   digits = digits - mean_vector;
   
   [dimensions, bases] = highest_dimensions(digits, 84);
   
   reduced_data = bases'*digits; % in form of coefficients along bases
   
   reconstructed = bases*reduced_data;
   
   figure(d+1);
   axis equal;
   subplot(1, 2, 1);
   imagesc(reshape(mean_vector + digits(:, 2), [28 28]));
   title(["Original Image for Digit " num2str(d)]);
   
   subplot(1, 2, 2);
   imagesc(reshape(mean_vector + reconstructed(:, 2), [28 28]));
   title(["Reconstructed Image for Digit " num2str(d)]);
end