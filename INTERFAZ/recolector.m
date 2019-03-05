function [r] = recolector(sunSys)

    if sunSys == 0
%         errordlg('','No se pudo conectar al puerto ');
        r = 0;
    else
        fopen(sunSys)
        r = fscanf(sunSys)
        fclose(sunSys)
    end
end

