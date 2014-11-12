CREATE TABLE [dbo].[Tipo_Movimento_Cone] (
    [cd_tipo_movimento] INT          NOT NULL,
    [nm_tipo_movimento] VARCHAR (40) NULL,
    [sg_tipo_movimento] VARCHAR (15) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]        INT          NOT NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK__Tipo_Movimento_C__3493CFA7] PRIMARY KEY CLUSTERED ([cd_tipo_movimento] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [XIF6Tipo_Movimento_Cone]
    ON [dbo].[Tipo_Movimento_Cone]([cd_usuario] ASC) WITH (FILLFACTOR = 90);


GO
create trigger tU_Tipo_Movimento_Cone on dbo.Tipo_Movimento_Cone for UPDATE as
/* ERwin Builtin Mon Dec 04 12:02:58 2000 */
/* UPDATE trigger on Tipo_Movimento_Cone */
begin
  declare  @numrows int,
           @nullcnt int,
           @validcnt int,
           @inscd_tipo_movimento int,
           @errno   int,
           @errmsg  varchar(255)
  select @numrows = @@rowcount
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Tipo_Movimento_Cone R/12 Movimento_Cone ON PARENT UPDATE SET NULL */
  if
    /* %ParentPK(" or",update) */
    update(cd_tipo_movimento)
  begin
    update Movimento_Cone
      set
        /* %SetFK(Movimento_Cone,NULL) */
        Movimento_Cone.cd_tipo_movimento = NULL
      from Movimento_Cone,deleted
      where
        /* %JoinFKPK(Movimento_Cone,deleted," = "," and") */
        Movimento_Cone.cd_tipo_movimento = deleted.cd_tipo_movimento
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/6 Tipo_Movimento_Cone ON CHILD UPDATE SET NULL */
  if
    /* %ChildFK(" or",update) */
    update(cd_usuario)
  begin
    update Tipo_Movimento_Cone
      set
        /* %SetFK(Tipo_Movimento_Cone,NULL) */
        Tipo_Movimento_Cone.cd_usuario = NULL
      from Tipo_Movimento_Cone,inserted
      where
        /* %JoinPKPK(Tipo_Movimento_Cone,inserted," = "," and") */
        Tipo_Movimento_Cone.cd_tipo_movimento = inserted.cd_tipo_movimento and 
        not exists (
          select * from Usuario
          where
            /* %JoinFKPK(inserted,Usuario," = "," and") */
            inserted.cd_usuario = Usuario.cd_usuario
        )
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  return
error:
    raiserror @errno @errmsg
    rollback transaction
end

GO
create trigger tI_Tipo_Movimento_Cone on dbo.Tipo_Movimento_Cone for INSERT as
/* ERwin Builtin Mon Dec 04 12:02:58 2000 */
/* INSERT trigger on Tipo_Movimento_Cone */
begin
  declare  @numrows int,
           @nullcnt int,
           @validcnt int,
           @errno   int,
           @errmsg  varchar(255)
  select @numrows = @@rowcount
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  /* Usuario R/6 Tipo_Movimento_Cone ON CHILD INSERT SET NULL */
  if
    /* %ChildFK(" or",update) */
    update(cd_usuario)
  begin
    update Tipo_Movimento_Cone
      set
        /* %SetFK(Tipo_Movimento_Cone,NULL) */
        Tipo_Movimento_Cone.cd_usuario = NULL
      from Tipo_Movimento_Cone,inserted
      where
        /* %JoinPKPK(Tipo_Movimento_Cone,inserted," = "," and") */
        Tipo_Movimento_Cone.cd_tipo_movimento = inserted.cd_tipo_movimento and
        not exists (
          select * from Usuario
          where
            /* %JoinFKPK(inserted,Usuario," = "," and") */
            inserted.cd_usuario = Usuario.cd_usuario
        )
  end
  /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
  return
error:
    raiserror @errno @errmsg
    rollback transaction
end

GO
create trigger tD_Tipo_Movimento_Cone on dbo.Tipo_Movimento_Cone for DELETE as
/* ERwin Builtin Mon Dec 04 12:02:58 2000 */
/* DELETE trigger on Tipo_Movimento_Cone */
begin
  declare  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    /* Tipo_Movimento_Cone R/12 Movimento_Cone ON PARENT DELETE SET NULL */
    update Movimento_Cone
      set
        /* %SetFK(Movimento_Cone,NULL) */
        Movimento_Cone.cd_tipo_movimento = NULL
      from Movimento_Cone,deleted
      where
        /* %JoinFKPK(Movimento_Cone,deleted," = "," and") */
        Movimento_Cone.cd_tipo_movimento = deleted.cd_tipo_movimento
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    return
error:
    raiserror @errno @errmsg
    rollback transaction
end
