CREATE TABLE [dbo].[Cone] (
    [cd_cone]        INT          NOT NULL,
    [nm_cone]        VARCHAR (40) NULL,
    [sg_cone]        CHAR (15)    NULL,
    [nm_imagem_cone] CHAR (50)    NULL,
    [cd_tipo_cone]   INT          NULL,
    [ic_status_cone] INT          NULL,
    [ic_cone_ativo]  CHAR (1)     NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    [cd_estado]      INT          NULL,
    CONSTRAINT [PK__Cone__36D11DD4] PRIMARY KEY CLUSTERED ([cd_cone] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [_WA_Sys_ic_status_cone_3335971A]
    ON [dbo].[Cone]([ic_status_cone] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_WA_Sys_nm_imagem_cone_3335971A]
    ON [dbo].[Cone]([nm_imagem_cone] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_WA_Sys_sg_cone_3335971A]
    ON [dbo].[Cone]([sg_cone] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_WA_Sys_nm_cone_3335971A]
    ON [dbo].[Cone]([nm_cone] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Cone]
    ON [dbo].[Cone]([cd_tipo_cone] ASC) WITH (FILLFACTOR = 90);


GO
create trigger tD_Cone on dbo.Cone
  for DELETE
  as
/* ERwin Builtin Mon Dec 04 12:02:58 2000 */
/* DELETE trigger on Cone */
begin
  declare  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Mon Dec 04 12:02:57 2000 */
    /* Cone R/19 Montagem_Cone ON PARENT DELETE RESTRICT */
    if exists (
      select * from deleted,Montagem_Cone
      where
        /*  %JoinFKPK(Montagem_Cone,deleted," = "," and") */
        Montagem_Cone.cd_cone = deleted.cd_cone
    )
    begin
      select @errno  = 30001,
             @errmsg = 'Cannot DELETE Cone because Montagem_Cone exists.'
      goto error
    end
    /* ERwin Builtin Mon Dec 04 12:02:57 2000 */
    /* Cone R/17 Ferramenta_Cone ON PARENT DELETE RESTRICT */
    if exists (
      select * from deleted,Ferramenta_Cone
      where
        /*  %JoinFKPK(Ferramenta_Cone,deleted," = "," and") */
        Ferramenta_Cone.cd_cone = deleted.cd_cone
    )
    begin
      select @errno  = 30001,
             @errmsg = 'Cannot DELETE Cone because Ferramenta_Cone exists.'
      goto error
    end
    /* ERwin Builtin Mon Dec 04 12:02:57 2000 */
    /* Cone R/14 Movimento_Cone ON PARENT DELETE RESTRICT */
    if exists (
      select * from deleted,Movimento_Cone
      where
        /*  %JoinFKPK(Movimento_Cone,deleted," = "," and") */
        Movimento_Cone.cd_cone = deleted.cd_cone
    )
    begin
      select @errno  = 30001,
             @errmsg = 'Cannot DELETE Cone because Movimento_Cone exists.'
      goto error
    end
    /* ERwin Builtin Mon Dec 04 12:02:58 2000 */
    return
error:
    raiserror @errno @errmsg
    rollback transaction
end
