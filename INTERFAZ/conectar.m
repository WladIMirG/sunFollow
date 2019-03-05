function [sunSys] = conectar(puerto)
% Esta funcion conecta con el puerto serial deseado
    sunSys = serial(puerto)
    fopen(sunSys)
    errordlg('Se conecto con exito','Exito');
    pause(1)
%     fclose(sunSys)
end
