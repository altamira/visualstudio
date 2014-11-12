CREATE TABLE [dbo].[Clube_Local] (
    [cd_local]       INT          NOT NULL,
    [nm_local]       VARCHAR (40) NULL,
    [ic_ativo_local] CHAR (1)     NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Clube_Local] PRIMARY KEY CLUSTERED ([cd_local] ASC)
);

