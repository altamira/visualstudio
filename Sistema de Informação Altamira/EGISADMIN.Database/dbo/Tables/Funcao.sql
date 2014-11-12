CREATE TABLE [dbo].[Funcao] (
    [cd_funcao]    INT          NOT NULL,
    [nm_funcao]    VARCHAR (20) NULL,
    [ds_funcao]    TEXT         NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    [ic_alteracao] CHAR (1)     NULL,
    CONSTRAINT [PK_Funcao] PRIMARY KEY CLUSTERED ([cd_funcao] ASC) WITH (FILLFACTOR = 90)
);

