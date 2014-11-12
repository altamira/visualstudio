
CREATE PROCEDURE pr_acompanhamento_inventario_fisico

@dt_inventario   datetime,
@cd_fase_produto int = 0,
@nm_modulo	 varchar(10) = '',
@nm_produto  varchar(30) = ''

AS

  select
    identity(int,1,1)                                                   as cd_controle,
    i.cd_produto,
    i.cd_fase_produto,
    i.dt_inventario,
    case when i.qt_contagem1 is not null then 1 else 0 end 		as ic_qt1,
    case when i.qt_contagem2 is not null then 1 else 0 end 		as ic_qt2,
    case when i.qt_contagem3 is not null then 1 else 0 end 		as ic_qt3,
    case when i.qt_contagem4 is not null then 1 else 0 end 		as ic_qt4,
    case when i.qt_contagem5 is not null then 1 else 0 end 		as ic_qt5,
    case when i.qt_real is not null then 1 else 0 end 			as ic_qt_real,
    fp.sg_fase_produto							as sg_fase_produto,
    isnull(i.nm_modulo_localizacao,'') 					as nm_modulo,
    isnull(i.nm_localizacao_produto,'') 				as nm_endereco,
    ltrim(rtrim(isnull(p.nm_fantasia_produto,'')))			as nm_fantasia_produto,
    cast(i.qt_atual_sistema as money)					as qt_sistema,
    cast(i.qt_contagem1 as money)					as qt_contagem1,
    cast(i.qt_contagem2 as money)					as qt_contagem2,
    cast(i.qt_contagem3 as money)					as qt_contagem3,
    cast(i.qt_contagem4 as money)					as qt_contagem4,
    cast(i.qt_contagem5 as money)					as qt_contagem5,
    cast(i.qt_real as money)						as qt_real,
    p.nm_produto,
    um.sg_unidade_medida  

  into
    #Inventario

  from
   Inventario_Fisico 	i  	left outer join
   Fase_Produto		fp 	on i.cd_fase_produto = fp.cd_fase_produto left outer join
   Produto		p	on i.cd_produto = p.cd_produto
   left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida

  where
    i.dt_inventario 		= @dt_inventario and
    i.cd_fase_produto 		= case when isnull(@cd_fase_produto,0) > 0 then @cd_fase_produto else i.cd_fase_produto end and
    i.nm_modulo_localizacao	like case when ltrim(rtrim(isnull(@nm_modulo,''))) <> '' then ltrim(rtrim(isnull(@nm_modulo,''))) + '%' else i.nm_modulo_localizacao end and
    p.nm_fantasia_produto like Case 
                                 when Ltrim(RTrim(IsNull(@nm_produto,''))) <> ''
                                   Then '%' + Ltrim(Rtrim(IsNull(@nm_produto,''))) + '%' 
                                 else p.nm_fantasia_produto    
                               End 
  order by
    fp.sg_fase_produto,
    isnull(i.nm_modulo_localizacao,''),
    isnull(i.nm_localizacao_produto,''),
    ltrim(rtrim(isnull(p.nm_fantasia_produto,''))) 

  select
    *
  from
    #Inventario
  order by
    sg_fase_produto,
    isnull(nm_modulo,''),
    isnull(nm_endereco,''),
    ltrim(rtrim(isnull(nm_fantasia_produto,''))) 


--update Inventario_Fisico set nm_modulo_localizacao = replace(nm_modulo_localizacao,' ','')

