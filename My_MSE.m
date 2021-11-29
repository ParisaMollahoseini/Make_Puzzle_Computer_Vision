function output = My_MSE(I,J)
output = sum(sum((I-J).^2))/(numel(I));
end