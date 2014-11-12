CREATE TABLE [dbo].[Tipo_Desligamento] (
    [cd_tipo_desligamento]       INT          NOT NULL,
    [nm_tipo_desligamento]       VARCHAR (40) NULL,
    [sg_tipo_desligamento]       CHAR (10)    NULL,
    [cd_usuario]                 INT          NULL,
    [dt_atualizacao]             DATETIME     NULL,
    [cd_caged_tipo_desligamento] CHAR (2)     NULL,
    CONSTRAINT [PK_Tipo_Desligamento] PRIMARY KEY CLUSTERED ([cd_tipo_desligamento] ASC) WITH (FILLFACTOR = 90)
);

