

CREATE procedure sp_ConsultaLog
@dt_Inicial datetime,
@dt_Final datetime,
@cd_usuario int,
@cd_modulo int
AS
BEGIN

/*Filtra todos os acessos filtrando por módulo e usuário*/
if (@cd_usuario > 0) and (@cd_modulo > 0) begin 
Select 
L.*,
Tipo = case L.sg_Log_Acesso
       when 0 then 'Entrou'
       when 1 then 'Saiu'
end,
U.nm_usuario, 
MN.nm_menu, 
nm_modulo = case L.cd_modulo
            when 0 then 'EGIS-Sistema Integrado de Gestão Empresarial'
            else M.nm_modulo
            end
From LogAcesso L, Usuario U, Menu MN, Modulo M
Where L.cd_usuario = U.cd_usuario 
     and L.cd_menu    *= MN.cd_menu 
     and L.cd_modulo  *= M.cd_modulo
and L.dt_Log_Acesso >= @dt_Inicial
and L.dt_Log_Acesso <= @dt_Final
and L.cd_usuario = @cd_usuario
and L.cd_modulo = @cd_modulo

/*Filtra todos os acessos filtrando somente por módulo*/
end else if (@cd_usuario = 0) and (@cd_modulo > 0) begin  
Select 
L.*,
Tipo = case L.sg_Log_Acesso
       when 0 then 'Entrou'
       when 1 then 'Saiu'
end,
U.nm_usuario, 
MN.nm_menu, 
nm_modulo = case L.cd_modulo
            when 0 then 'EGIS-Sistema Integrado de Gestão Empresarial'
            else M.nm_modulo
            end
From LogAcesso L, Usuario U, Menu MN, Modulo M
Where L.cd_usuario = U.cd_usuario 
     and L.cd_menu    *= MN.cd_menu 
     and L.cd_modulo  *= M.cd_modulo
and L.dt_Log_Acesso >= @dt_Inicial
and L.dt_Log_Acesso <= @dt_Final
and L.cd_modulo = @cd_modulo

/*Filtra todos os acessos filtrando somente por módulo*/   
end else if (@cd_usuario > 0) and (@cd_modulo = 0) begin
Select 
L.*,
Tipo = case L.sg_Log_Acesso
       when 0 then 'Entrou'
       when 1 then 'Saiu'
end,
U.nm_usuario, 
MN.nm_menu, 
nm_modulo = case L.cd_modulo
            when 0 then 'EGIS-Sistema Integrado de Gestão Empresarial'
            else M.nm_modulo
            end
From LogAcesso L, Usuario U, Menu MN, Modulo M
Where L.cd_usuario = U.cd_usuario 
     and L.cd_menu    *= MN.cd_menu 
     and L.cd_modulo  *= M.cd_modulo
and L.dt_Log_Acesso >= @dt_Inicial
and L.dt_Log_Acesso <= @dt_Final
and L.cd_usuario = @cd_usuario

/*Caso não tenha sido informado o usuário nem o módulo*/
end else begin
Select 
L.*,
Tipo = case L.sg_Log_Acesso
       when 0 then 'Entrou'
       when 1 then 'Saiu'
end,
U.nm_usuario, 
MN.nm_menu, 
nm_modulo = case L.cd_modulo
            when 0 then 'EGIS-Sistema Integrado de Gestão Empresarial'
            else M.nm_modulo
            end
From LogAcesso L, Usuario U, Menu MN, Modulo M
Where L.cd_usuario = U.cd_usuario 
     and L.cd_menu    *= MN.cd_menu 
     and L.cd_modulo  *= M.cd_modulo
and L.dt_Log_Acesso >= @dt_Inicial
and L.dt_Log_Acesso <= @dt_Final
end
end

