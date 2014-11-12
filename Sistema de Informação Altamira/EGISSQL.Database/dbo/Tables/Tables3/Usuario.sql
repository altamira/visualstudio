CREATE TABLE [dbo].[Usuario] (
    [cd_usuario]               INT           NOT NULL,
    [nm_usuario]               VARCHAR (40)  NOT NULL,
    [nm_fantasia_usuario]      CHAR (15)     NOT NULL,
    [cd_senha_usuario]         CHAR (10)     NULL,
    [dt_nascto_usuario]        DATETIME      NULL,
    [cd_depto]                 INT           NULL,
    [nm_email_usuario]         CHAR (50)     NULL,
    [nm_email_interno]         VARCHAR (100) NULL,
    [cd_telefone_usuario]      CHAR (8)      NULL,
    [cd_celular_usuario]       CHAR (8)      NULL,
    [cd_vendedor]              INT           NULL,
    [ic_lista_aniversariantes] CHAR (1)      COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    CONSTRAINT [PK__Usuario__3864608B] PRIMARY KEY CLUSTERED ([cd_usuario] ASC) WITH (FILLFACTOR = 90)
);


GO
create trigger tD_Usuario on dbo.Usuario for DELETE as
/* ERwin Builtin Mon Dec 04 12:02:58 2000 */
/* DELETE trigger on Usuario */
begin
  declare  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Usuario R/25 GrupoProduto ON PARENT DELETE SET NULL */
    update GrupoProduto
      set
        /* %SetFK(GrupoProduto,NULL) */
        GrupoProduto.cd_usuario = NULL
      from GrupoProduto,deleted
      where
        /* %JoinFKPK(GrupoProduto,deleted," = "," and") */
        GrupoProduto.cd_usuario = deleted.cd_usuario
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Usuario R/24 Produto ON PARENT DELETE SET NULL */
    update Produto
      set
        /* %SetFK(Produto,NULL) */
        Produto.cd_usuario = NULL
      from Produto,deleted
      where
        /* %JoinFKPK(Produto,deleted," = "," and") */
        Produto.cd_usuario = deleted.cd_usuario
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Usuario R/23 Montagem_Cone ON PARENT DELETE SET NULL */
    update Montagem_Cone
      set
        /* %SetFK(Montagem_Cone,NULL) */
        Montagem_Cone.cd_usuario = NULL
      from Montagem_Cone,deleted
      where
        /* %JoinFKPK(Montagem_Cone,deleted," = "," and") */
        Montagem_Cone.cd_usuario = deleted.cd_usuario
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Usuario R/18 Ferramenta_Cone ON PARENT DELETE SET NULL */
    update Ferramenta_Cone
      set
        /* %SetFK(Ferramenta_Cone,NULL) */
        Ferramenta_Cone.cd_usuario = NULL
      from Ferramenta_Cone,deleted
      where
        /* %JoinFKPK(Ferramenta_Cone,deleted," = "," and") */
        Ferramenta_Cone.cd_usuario = deleted.cd_usuario
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Usuario R/13 Movimento_Cone ON PARENT DELETE SET NULL */
    update Movimento_Cone
      set
        /* %SetFK(Movimento_Cone,NULL) */
        Movimento_Cone.cd_usuario = NULL
      from Movimento_Cone,deleted
      where
        /* %JoinFKPK(Movimento_Cone,deleted," = "," and") */
        Movimento_Cone.cd_usuario = deleted.cd_usuario
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Usuario R/11 Maquina ON PARENT DELETE SET NULL */
    update Maquina
      set
        /* %SetFK(Maquina,NULL) */
        Maquina.cd_usuario = NULL
      from Maquina,deleted
      where
        /* %JoinFKPK(Maquina,deleted," = "," and") */
        Maquina.cd_usuario = deleted.cd_usuario
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Usuario R/9 Grupo_Ferramenta ON PARENT DELETE SET NULL */
    update Grupo_Ferramenta
      set
        /* %SetFK(Grupo_Ferramenta,NULL) */
        Grupo_Ferramenta.cd_usuario = NULL
      from Grupo_Ferramenta,deleted
      where
        /* %JoinFKPK(Grupo_Ferramenta,deleted," = "," and") */
        Grupo_Ferramenta.cd_usuario = deleted.cd_usuario
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Usuario R/8 Ferramenta ON PARENT DELETE SET NULL */
    update Ferramenta
      set
        /* %SetFK(Ferramenta,NULL) */
        Ferramenta.cd_usuario = NULL
      from Ferramenta,deleted
      where
        /* %JoinFKPK(Ferramenta,deleted," = "," and") */
        Ferramenta.cd_usuario = deleted.cd_usuario
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Usuario R/6 Tipo_Movimento_Cone ON PARENT DELETE SET NULL */
    update Tipo_Movimento_Cone
      set
        /* %SetFK(Tipo_Movimento_Cone,NULL) */
        Tipo_Movimento_Cone.cd_usuario = NULL
      from Tipo_Movimento_Cone,deleted
      where
        /* %JoinFKPK(Tipo_Movimento_Cone,deleted," = "," and") */
        Tipo_Movimento_Cone.cd_usuario = deleted.cd_usuario
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Usuario R/4 Cone ON PARENT DELETE SET NULL */
    update Cone
      set
        /* %SetFK(Cone,NULL) */
        Cone.cd_usuario = NULL
      from Cone,deleted
      where
 /* %JoinFKPK(Cone,deleted," = "," and") */
        Cone.cd_usuario = deleted.cd_usuario
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Usuario R/3 Tipo_Cone ON PARENT DELETE SET NULL */
    update Tipo_Cone
      set
        /* %SetFK(Tipo_Cone,NULL) */
        Tipo_Cone.cd_usuario = NULL
      from Tipo_Cone,deleted
      where
        /* %JoinFKPK(Tipo_Cone,deleted," = "," and") */
        Tipo_Cone.cd_usuario = deleted.cd_usuario
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    return
error:
    raiserror @errno @errmsg
    rollback transaction
end

GO
create trigger tU_Usuario on dbo.Usuario for UPDATE as
/* ERwin Builtin Mon Dec 04 12:02:58 2000 */
/* UPDATE trigger on Usuario */
begin
  declare  @numrows int,
           @nullcnt int,
           @validcnt int,
           @inscd_usuario int,
           @errno   int,
           @errmsg  varchar(255)
  select @numrows = @@rowcount
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/25 GrupoProduto ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_usuario)
  begin
    update GrupoProduto
      set
        /* %SetFK(GrupoProduto,NULL) */
        GrupoProduto.cd_usuario = NULL
      from GrupoProduto,deleted
      where
        /* %JoinFKPK(GrupoProduto,deleted," = "," and") */
        GrupoProduto.cd_usuario = deleted.cd_usuario
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/24 Produto ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_usuario)
  begin
    update Produto
      set
        /* %SetFK(Produto,NULL) */
        Produto.cd_usuario = NULL
      from Produto,deleted
      where
        /* %JoinFKPK(Produto,deleted," = "," and") */
        Produto.cd_usuario = deleted.cd_usuario
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/23 Montagem_Cone ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_usuario)
  begin
    update Montagem_Cone
      set
        /* %SetFK(Montagem_Cone,NULL) */
        Montagem_Cone.cd_usuario = NULL
      from Montagem_Cone,deleted
      where
        /* %JoinFKPK(Montagem_Cone,deleted," = "," and") */
        Montagem_Cone.cd_usuario = deleted.cd_usuario
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/18 Ferramenta_Cone ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_usuario)
  begin
    update Ferramenta_Cone
      set
        /* %SetFK(Ferramenta_Cone,NULL) */
        Ferramenta_Cone.cd_usuario = NULL
      from Ferramenta_Cone,deleted
      where
        /* %JoinFKPK(Ferramenta_Cone,deleted," = "," and") */
        Ferramenta_Cone.cd_usuario = deleted.cd_usuario
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/13 Movimento_Cone ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_usuario)
  begin
    update Movimento_Cone
      set
        /* %SetFK(Movimento_Cone,NULL) */
        Movimento_Cone.cd_usuario = NULL
      from Movimento_Cone,deleted
      where
        /* %JoinFKPK(Movimento_Cone,deleted," = "," and") */
        Movimento_Cone.cd_usuario = deleted.cd_usuario
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/11 Maquina ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_usuario)
  begin
    update Maquina
      set
        /* %SetFK(Maquina,NULL) */
        Maquina.cd_usuario = NULL
      from Maquina,deleted
      where
        /* %JoinFKPK(Maquina,deleted," = "," and") */
        Maquina.cd_usuario = deleted.cd_usuario
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/9 Grupo_Ferramenta ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_usuario)
  begin
    update Grupo_Ferramenta
      set
        /* %SetFK(Grupo_Ferramenta,NULL) */
        Grupo_Ferramenta.cd_usuario = NULL
      from Grupo_Ferramenta,deleted
      where
        /* %JoinFKPK(Grupo_Ferramenta,deleted," = "," and") */
        Grupo_Ferramenta.cd_usuario = deleted.cd_usuario
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/8 Ferramenta ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_usuario)
  begin
    update Ferramenta
      set
        /* %SetFK(Ferramenta,NULL) */
        Ferramenta.cd_usuario = NULL
      from Ferramenta,deleted
      where
        /* %JoinFKPK(Ferramenta,deleted," = "," and") */
        Ferramenta.cd_usuario = deleted.cd_usuario
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/6 Tipo_Movimento_Cone ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_usuario)
  begin
    update Tipo_Movimento_Cone
      set
        /* %SetFK(Tipo_Movimento_Cone,NULL) */
        Tipo_Movimento_Cone.cd_usuario = NULL
      from Tipo_Movimento_Cone,deleted
      where
        /* %JoinFKPK(Tipo_Movimento_Cone,deleted," = "," and") */
        Tipo_Movimento_Cone.cd_usuario = deleted.cd_usuario
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/4 Cone ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_usuario)
  begin
    update Cone
      set
        /* %SetFK(Cone,NULL) */
        Cone.cd_usuario = NULL
      from Cone,deleted
      where
        /* %JoinFKPK(Cone,deleted," = "," and") */
        Cone.cd_usuario = deleted.cd_usuario
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/3 Tipo_Cone ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_usuario)
  begin
    update Tipo_Cone
      set
        /* %SetFK(Tipo_Cone,NULL) */
        Tipo_Cone.cd_usuario = NULL
      from Tipo_Cone,deleted
      where
        /* %JoinFKPK(Tipo_Cone,deleted," = "," and") */
        Tipo_Cone.cd_usuario = deleted.cd_usuario
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  return
error:
    raiserror @errno @errmsg
    rollback transaction
end
