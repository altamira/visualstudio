
CREATE PROCEDURE pr_geracao_tabela_inventario_fisico

@dt_inventario      dateTime = '',
@ic_parametro       int       = 0,
@ic_zera_inventario char(1)   = 'N'

as

--select * from inventario_fisico

--Zera o Inventário anterior na Data

if @ic_zera_inventario='S'
begin

  delete from inventario_fisico
  where
    dt_inventario = @dt_inventario

end

if exists (Select top 1 cd_produto 
           From Inventario_Fisico
           Where dt_inventario = @dt_inventario and
                 qt_real is not null)
     raiserror( 'Atenção, inventário já processado para a data selecionada ',16,1)
Else
  delete from Inventario_Fisico Where dt_inventario = @dt_inventario

if @@ERROR <> 0
   return  

--Data do Fechamento----------------------------------------------------------------------------------------

if @ic_parametro = 0
begin

Insert into Inventario_Fisico (dt_inventario, cd_fase_produto, cd_produto, 
                               nm_localizacao_produto, nm_modulo_localizacao, qt_atual_sistema)

Select pf.dt_produto_fechamento,
       pf.cd_fase_produto,
       pf.cd_produto,
       IsNull(dbo.fn_getlocalizacao_produto_fase(pf.cd_produto, pf.cd_fase_produto),'') as nm_localizacao_produto,
       IsNull((LTrim(RTRim((Select qt_posicao_localizacao
                            From Produto_Localizacao PL
                            Where pl.cd_produto = pf.cd_produto and
                                  pl.cd_fase_produto = pf.cd_fase_produto and
                                  cd_grupo_localizacao = 1))) + 
               LTrim(RTrim((Select qt_posicao_localizacao
                            From Produto_Localizacao PL
                            Where pl.cd_produto = pf.cd_produto and
                                  pl.cd_fase_produto = pf.cd_fase_produto and
                                  cd_grupo_localizacao = 2)))),'') as nm_modulo_localizacao,
       pf.qt_atual_prod_fechamento
From Produto_Fechamento PF
Where pf.dt_produto_fechamento = @dt_inventario
Order By pf.dt_produto_fechamento, pf.cd_produto, pf.cd_fase_produto



Update Inventario_Fisico 
Set nm_modulo_localizacao = 'Sem Modulo'
Where LTrim(RTrim(nm_modulo_localizacao)) = '' and
      dt_inventario = @dt_inventario

end

------------------------------------------------------------------------------
--Saldo Atual
------------------------------------------------------------------------------

if @ic_parametro = 1
begin

  declare @dt_hoje datetime

  set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)


Insert into Inventario_Fisico (dt_inventario, cd_fase_produto, cd_produto, 
                               nm_localizacao_produto, nm_modulo_localizacao, qt_atual_sistema)

Select @dt_inventario,
       ps.cd_fase_produto,
       ps.cd_produto,
       IsNull(dbo.fn_getlocalizacao_produto_fase(ps.cd_produto, ps.cd_fase_produto),'') as nm_localizacao_produto,
       IsNull((LTrim(RTRim((Select qt_posicao_localizacao
                            From Produto_Localizacao PL
                            Where pl.cd_produto = ps.cd_produto and
                                  pl.cd_fase_produto = ps.cd_fase_produto and
                                  cd_grupo_localizacao = 1))) + 
               LTrim(RTrim((Select qt_posicao_localizacao
                            From Produto_Localizacao PL
                            Where pl.cd_produto = ps.cd_produto and
                                  pl.cd_fase_produto = ps.cd_fase_produto and
                                  cd_grupo_localizacao = 2)))),'') as nm_modulo_localizacao,
       ps.qt_saldo_atual_produto
From
   Produto_Saldo ps with (nolock) 
   inner join produto p on p.cd_produto = ps.cd_produto
   inner join status_produto sp on sp.cd_status_produto  = p.cd_status_produto
where
  isnull(sp.ic_bloqueia_uso_produto,'N')='N'

--select * from status_produto

--Where pf.dt_produto_fechamento = @dt_inventario
--select * from produto_saldo

Order By 
  ps.cd_produto, ps.cd_fase_produto


Update Inventario_Fisico 
Set nm_modulo_localizacao = 'Sem Localização'
Where LTrim(RTrim(nm_modulo_localizacao)) = '' and
      dt_inventario = @dt_inventario


end

