CREATE TABLE [dbo].[Montagem_Cone] (
    [cd_cone]               INT      NOT NULL,
    [cd_item_montagem_cone] INT      NOT NULL,
    [cd_grupo_ferramenta]   INT      NULL,
    [cd_grupo_produto]      INT      NULL,
    [cd_ferramenta]         INT      NULL,
    [cd_produto]            CHAR (9) NULL,
    [cd_usuario]            INT      NOT NULL,
    [dt_usuario]            DATETIME NULL,
    PRIMARY KEY CLUSTERED ([cd_cone] ASC, [cd_item_montagem_cone] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [XIF19Montagem_Cone]
    ON [dbo].[Montagem_Cone]([cd_cone] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [XIF22Montagem_Cone]
    ON [dbo].[Montagem_Cone]([cd_grupo_produto] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [XIF29Montagem_Cone]
    ON [dbo].[Montagem_Cone]([cd_grupo_ferramenta] ASC, [cd_ferramenta] ASC) WITH (FILLFACTOR = 90);


GO
create trigger tU_Montagem_Cone on Montagem_Cone
  for UPDATE
  as
/* ERwin Builtin Mon Dec 04 12:02:58 2000 */
/* UPDATE trigger on Montagem_Cone */
begin
  declare  @numrows int,
           @nullcnt int,
           @validcnt int,
           @inscd_cone int, 
           @inscd_item_montagem_cone int,
           @errno   int,
           @errmsg  varchar(255)
  select @numrows = @@rowcount
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Montagem_Cone R/26 Fornecedor_Cone ON PARENT UPDATE RESTRICT */
  if
    /* %ParentPK(" or",update) */
    update(cd_cone) or
    update(cd_item_montagem_cone)
  begin
    if exists (
      select * from deleted,Fornecedor_Cone
      where
        /*  %JoinFKPK(Fornecedor_Cone,deleted," = "," and") */
        Fornecedor_Cone.cd_cone = deleted.cd_cone and
        Fornecedor_Cone.cd_item_montagem_cone = deleted.cd_item_montagem_cone
    )
    begin
      select @errno  = 30005,
             @errmsg = 'Cannot UPDATE Montagem_Cone because Fornecedor_Cone exists.'
      goto error
    end
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/23 Montagem_Cone ON CHILD UPDATE SET NULL */
  if
    /* %ChildFK(" or",update) */
    update(cd_usuario)
  begin
    update Montagem_Cone
      set
        /* %SetFK(Montagem_Cone,NULL) */
        Montagem_Cone.cd_usuario = NULL
      from Montagem_Cone,inserted
      where
        /* %JoinPKPK(Montagem_Cone,inserted," = "," and") */
        Montagem_Cone.cd_cone = inserted.cd_cone and
        Montagem_Cone.cd_item_montagem_cone = inserted.cd_item_montagem_cone and 
        not exists (
          select * from Usuario
          where
            /* %JoinFKPK(inserted,Usuario," = "," and") */
            inserted.cd_usuario = Usuario.cd_usuario
        )
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Produto R/22 Montagem_Cone ON CHILD UPDATE SET NULL */
  if
    /* %ChildFK(" or",update) */
    update(cd_grupo_produto) or
    update(cd_produto)
  begin
    update Montagem_Cone
      set
        /* %SetFK(Montagem_Cone,NULL) */
        Montagem_Cone.cd_grupo_produto = NULL,
        Montagem_Cone.cd_produto = NULL
      from Montagem_Cone,inserted
      where
        /* %JoinPKPK(Montagem_Cone,inserted," = "," and") */
        Montagem_Cone.cd_cone = inserted.cd_cone and
        Montagem_Cone.cd_item_montagem_cone = inserted.cd_item_montagem_cone and 
        not exists (
          select * from Produto
          where
            /* %JoinFKPK(inserted,Produto," = "," and") */
            inserted.cd_grupo_produto = Produto.cd_grupo_produto and
            inserted.cd_produto = Produto.cd_produto
        )
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Cone R/19 Montagem_Cone ON CHILD UPDATE RESTRICT */
  if
    /* %ChildFK(" or",update) */
    update(cd_cone)
  begin
    select @nullcnt = 0
    select @validcnt = count(*)
      from inserted,Cone
        where
          /* %JoinFKPK(inserted,Cone) */
          inserted.cd_cone = Cone.cd_cone
    /* %NotnullFK(inserted," is null","select @nullcnt = count(*) from inserted where"," and") */
    
    if @validcnt + @nullcnt != @numrows
    begin
      select @errno  = 30007,
             @errmsg = 'Cannot UPDATE Montagem_Cone because Cone does not exist.'
      goto error
    end
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  return
error:
    raiserror @errno @errmsg
    rollback transaction
end

GO
create trigger tD_Montagem_Cone on Montagem_Cone
  for DELETE
  as
/* ERwin Builtin Mon Dec 04 12:02:58 2000 */
/* DELETE trigger on Montagem_Cone */
begin
  declare  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Montagem_Cone R/26 Fornecedor_Cone ON PARENT DELETE RESTRICT */
    if exists (
      select * from deleted,Fornecedor_Cone
      where
        /*  %JoinFKPK(Fornecedor_Cone,deleted," = "," and") */
        Fornecedor_Cone.cd_cone = deleted.cd_cone and
        Fornecedor_Cone.cd_item_montagem_cone = deleted.cd_item_montagem_cone
    )
    begin
      select @errno  = 30001,
             @errmsg = 'Cannot DELETE Montagem_Cone because Fornecedor_Cone exists.'
      goto error
    end
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    return
error:
    raiserror @errno @errmsg
    rollback transaction
end

GO
create trigger tI_Montagem_Cone on Montagem_Cone
  for INSERT
  as
/* ERwin Builtin Mon Dec 04 12:02:58 2000 */
/* INSERT trigger on Montagem_Cone */
begin
  declare  @numrows int,
           @nullcnt int,
           @validcnt int,
           @errno   int,
           @errmsg  varchar(255)
  select @numrows = @@rowcount
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/23 Montagem_Cone ON CHILD INSERT SET NULL */
  if
    /* %ChildFK(" or",update) */
    update(cd_usuario)
  begin
    update Montagem_Cone
      set
        /* %SetFK(Montagem_Cone,NULL) */
        Montagem_Cone.cd_usuario = NULL
      from Montagem_Cone,inserted
      where
        /* %JoinPKPK(Montagem_Cone,inserted," = "," and") */
        Montagem_Cone.cd_cone = inserted.cd_cone and
        Montagem_Cone.cd_item_montagem_cone = inserted.cd_item_montagem_cone and
        not exists (
          select * from Usuario
          where
            /* %JoinFKPK(inserted,Usuario," = "," and") */
            inserted.cd_usuario = Usuario.cd_usuario
        )
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Produto R/22 Montagem_Cone ON CHILD INSERT SET NULL */
  if
    /* %ChildFK(" or",update) */
    update(cd_grupo_produto) or
    update(cd_produto)
  begin
    update Montagem_Cone
      set
        /* %SetFK(Montagem_Cone,NULL) */
        Montagem_Cone.cd_grupo_produto = NULL,
        Montagem_Cone.cd_produto = NULL
      from Montagem_Cone,inserted
      where
        /* %JoinPKPK(Montagem_Cone,inserted," = "," and") */
        Montagem_Cone.cd_cone = inserted.cd_cone and
        Montagem_Cone.cd_item_montagem_cone = inserted.cd_item_montagem_cone and
        not exists (
          select * from Produto
          where
            /* %JoinFKPK(inserted,Produto," = "," and") */
            inserted.cd_grupo_produto = Produto.cd_grupo_produto and
            inserted.cd_produto = Produto.cd_produto
        )
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Cone R/19 Montagem_Cone ON CHILD INSERT RESTRICT */
  if
    /* %ChildFK(" or",update) */
    update(cd_cone)
  begin
    select @nullcnt = 0
    select @validcnt = count(*)
      from inserted,Cone
        where
          /* %JoinFKPK(inserted,Cone) */
          inserted.cd_cone = Cone.cd_cone
    /* %NotnullFK(inserted," is null","select @nullcnt = count(*) from inserted where"," and") */
    
    if @validcnt + @nullcnt != @numrows
    begin
      select @errno  = 30002,
             @errmsg = 'Cannot INSERT Montagem_Cone because Cone does not exist.'
      goto error
    end
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  return
error:
    raiserror @errno @errmsg
    rollback transaction
end
