rng(5);
C = [1.6250 -1.9486; -1.9486 3.8750];
MU = [1 2]';
axis equal;
[V,D] = eig(C);
V
A = V*(D^0.5);

ns = [10 10^2 10^3 10^4 10^5];

mean_boxplot_matrix = zeros(100, length(ns));
covariance_boxplot_matrix = zeros(100, length(ns));
for k = 1:length(ns)
   for m = 1:100
       n = ns(k);
       standard_sample = randn(2, n); % vectorised sampling
       sample = MU + A*standard_sample; % this gives a 2 x N matrix where every column is a sample

       mean_vector = [0 0]';
       for l=1:n
          mean_vector = mean_vector + sample(:, l); % this can be done using sum
          % but we have been instructed to use only eig and randn
       end
       mean_vector = mean_vector/n;
       
       error = norm(mean_vector - MU)/norm(MU);
       mean_boxplot_matrix(m, k) = error;
       
       sample = sample - mean_vector;
       current_covariance = zeros(2, 2);
       for l=1:n
           current_covariance = current_covariance + sample(:, l)*sample(:, l)';
           % the above adds all current terms for the lth sample to the
           % sample covariance
       end
       
       current_covariance = current_covariance/(n);
       
       error = norm(C - current_covariance, 'fro')/norm(C, 'fro');
       covariance_boxplot_matrix(m, k) = error;
   end
 
end

figure(1);
boxplot(mean_boxplot_matrix);
xlabel("log N");
ylabel("Relative error between ML estimate and true mean");

figure(2);
boxplot(covariance_boxplot_matrix);
xlabel("log N");
ylabel("Relative error between ML estimate and true covariance");

for k = 1:length(ns)
    n = ns(k);
    standard_sample = randn(2, n);
    sample = MU + A*standard_sample;
    
    mean_vector = [0 0]';
    for l=1:n
       mean_vector = mean_vector + sample(:, l); 
    end
    mean_vector = mean_vector/n;

    sample = sample - mean_vector;
    current_covariance = zeros(2, 2);
    for l=1:n
        current_covariance = current_covariance + sample(:, l)*sample(:, l)';
    end

    current_covariance = current_covariance/(n);
    [v,d] = eig(current_covariance);
    
    figure(2+k);
    
    sample = sample + mean_vector;
  
    scatter(sample(1, :), sample(2, :));
    axis equal;
    
    terminal_one = mean_vector + d(1,1)*v(:, 1);
    terminal_two = mean_vector + d(2,2)*v(:, 2);
    line([mean_vector(1) terminal_one(1)], [mean_vector(2) terminal_one(2)], 'Color', 'r', 'LineWidth', 1.5);
      
    line([mean_vector(1) terminal_two(1)], [mean_vector(2) terminal_two(2)], 'Color', 'r', 'LineWidth', 1.5);
%    
%     hold on;
%     quiver(mean_vector(1), mean_vector(2), d(2,2)*v(1,2), d(2,2)*v(2,2), 'Color', 'r', 'LineWidth', 1, 'MaxHeadSize', 0.5);
%     hold on;
%     quiver(mean_vector(1), mean_vector(2), d(1,1)*v(1,1), d(1,1)*v(2,1), 'Color', 'r', 'LineWidth', 1, 'MaxHeadSize', 4);
end