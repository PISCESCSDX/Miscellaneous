function [name, prefix]= path_last_element(path)
   index= strfind(path, '/');
   if path(end)== '/'
       name  = path(index(end - 1) + 1:end-1);
       prefix= path(1:index(end-1));
   else
       name= path(index(end) + 1:end);
       prefix= path(1:index(end));
   end
end