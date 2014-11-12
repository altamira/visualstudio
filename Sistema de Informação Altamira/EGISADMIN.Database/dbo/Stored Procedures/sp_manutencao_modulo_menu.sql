
CREATE PROCEDURE sp_manutencao_modulo_menu
   @ic_parametro Integer,
   @cd_modulo    Integer


AS

begin

--**********************************  Pesquisa por módulo *****************************************************
if @ic_parametro = 1 
--************************************************************************************************************
begin
 Select 
   m1.cd_menu,
   m.cd_modulo,
   f.cd_funcao,
   mfm.cd_indice,
   m.nm_modulo,
   f.nm_funcao,
   m1.nm_menu,
   m1.nm_menu_titulo,
   c.nm_classe,
   m1.ic_nucleo_menu,
   m1.ic_habilitado,
   m1.ic_grafico_menu,
   m1.ic_iso_menu,
   m1.ic_expandido_menu,
   m1.ic_mdi,
   cast(m1.ds_observacao_menu as varchar(3000)) as ds_observacao_menu


 from 
    Modulo_funcao_menu mfm                  
    inner join  modulo m on (mfm.cd_modulo = m.cd_modulo) 
    inner join  funcao f on (mfm.cd_funcao = f.cd_funcao) 
    inner join  Menu m1  on (mfm.cd_menu = m1.cd_menu)   
    left outer join  classe c on (m1.cd_classe = c.cd_classe)

 where 
    m.cd_modulo = @cd_modulo  and
    m1.cd_menu is not null    and 
    isnull(mfm.cd_modulo,0)>0 and
    isnull(mfm.cd_funcao,0)>0 

 order by 
    mfm.cd_indice

end

else
--**********************************  Pesquisa por módulo *****************************************************
if @ic_parametro = 2 
--************************************************************************************************************
begin
 Select 
   m1.cd_menu,
   m.cd_modulo,
   f.cd_funcao,
   mfm.cd_indice,
   m.nm_modulo,
   f.nm_funcao,
   m1.nm_menu,
   m1.nm_menu_titulo,
   c.nm_classe,
   m1.ic_nucleo_menu,
   m1.ic_habilitado,
   m1.ic_grafico_menu,
   m1.ic_iso_menu,
   m1.ic_expandido_menu,
   m1.ic_mdi,
   cast(m1.ds_observacao_menu as varchar(3000)) as ds_observacao_menu


 from 
    Modulo_funcao_menu mfm                    
    inner join  modulo m on (mfm.cd_modulo = m.cd_modulo) 
    inner join  funcao f on (mfm.cd_funcao = f.cd_funcao) 
    inner join  Menu m1  on (mfm.cd_menu = m1.cd_menu)   
    left outer join classe c on (m1.cd_classe = c.cd_classe)

 where 
    m1.cd_menu is not null    and
    isnull(mfm.cd_funcao,0)>0 and
    isnull(mfm.cd_modulo,0)>0 
    
 order by 
    mfm.cd_indice

end

end

