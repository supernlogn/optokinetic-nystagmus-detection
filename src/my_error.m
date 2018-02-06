function y=my_error(tarV,preV)
y = mean((tarV - preV) .* (tarV - preV));