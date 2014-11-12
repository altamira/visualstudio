create FUNCTION fn_extracao_parametro_orcamento
(@cd_variavel_orcamento varchar(15))

RETURNS float

as
begin

   declare @vl_parametro_orcamento float

   select 
     @vl_parametro_orcamento = vl_parametro_orcamento
   from 
     parametro_orcamento
   where
     cd_variavel_orcamento = @cd_variavel_orcamento

   return(@vl_parametro_orcamento)

end

