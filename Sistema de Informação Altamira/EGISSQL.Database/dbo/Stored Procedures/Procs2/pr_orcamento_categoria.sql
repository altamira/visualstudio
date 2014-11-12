
create procedure pr_orcamento_categoria

@cd_consulta               int,
@cd_item_consulta          int,
@cd_item_orcamento         int,
@cd_categoria_orcamento    int,
@qt_hora_item_orcamento    float,
@vl_custo_item_orcamento   float,
@cd_usuario                int, 
@ic_parametro              int

as

-------------------------------------------------------------------------------------------
if @ic_parametro = 1 -- Exclusão
-------------------------------------------------------------------------------------------
begin

   delete from Consulta_Item_Orcamento_Cat
   where cd_consulta = @cd_consulta and
         cd_item_consulta = @cd_item_consulta and
         cd_item_orcamento = @cd_item_orcamento

end

else

-------------------------------------------------------------------------------------------
if @ic_parametro = 2 -- Inclusão
-------------------------------------------------------------------------------------------
begin

   if @qt_hora_item_orcamento > 0
      
      if isnull((select count(*) 
                 from Consulta_Item_Orcamento_Cat 
                 where cd_consulta            = @cd_consulta and
                       cd_item_consulta       = @cd_item_consulta and
                       cd_item_orcamento      = @cd_item_orcamento and
                       cd_categoria_orcamento = @cd_categoria_orcamento),0) = 0 
         insert into Consulta_Item_Orcamento_Cat
        (cd_consulta, cd_item_consulta, cd_item_orcamento, cd_categoria_orcamento,
         qt_hora_item_orcamento, vl_custo_item_orcamento, cd_usuario, dt_usuario)
         values
        (@cd_consulta, @cd_item_consulta, @cd_item_orcamento, @cd_categoria_orcamento,
         isnull(@qt_hora_item_orcamento,0), isnull(@vl_custo_item_orcamento,0), @cd_usuario, GetDate())
      
      else
      
         update Consulta_Item_Orcamento_Cat
         set qt_hora_item_orcamento    = qt_hora_item_orcamento  + @qt_hora_item_orcamento, 
             vl_custo_item_orcamento   = vl_custo_item_orcamento + @vl_custo_item_orcamento, 
             cd_usuario                = @cd_usuario, 
             dt_usuario                = GetDate()
         where cd_consulta            = @cd_consulta and 
               cd_item_consulta       = @cd_item_consulta and 
               cd_item_orcamento      = @cd_item_orcamento and 
               cd_categoria_orcamento = @cd_categoria_orcamento
end

else

-------------------------------------------------------------------------------------------
if @ic_parametro = 3 -- EXCLUSÃO de tempos de TODAS AS PLACAS
-------------------------------------------------------------------------------------------
begin

   delete from Consulta_Item_Orcamento_Cat
   where cd_consulta = @cd_consulta and
         cd_item_consulta = @cd_item_consulta

end

