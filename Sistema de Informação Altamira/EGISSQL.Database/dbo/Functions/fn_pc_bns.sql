CREATE  FUNCTION fn_pc_bns()

RETURNS decimal(25,4)

AS
begin
  
  declare @pc_bns decimal(25,4)

  set @pc_bns = ( select top 1 pc_bns from Parametro_Bi where cd_empresa = dbo.fn_empresa() ) 
 
  return cast(@pc_bns / 100 as decimal(25,4))

end



