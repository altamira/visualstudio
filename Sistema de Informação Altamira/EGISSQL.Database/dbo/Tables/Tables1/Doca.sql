CREATE TABLE [dbo].[Doca] (
    [cd_doca]             INT          NOT NULL,
    [nm_doca]             VARCHAR (40) NULL,
    [sg_doca]             CHAR (10)    NULL,
    [ic_ativa_doca]       CHAR (1)     NULL,
    [ic_acesso_doca]      CHAR (1)     NULL,
    [ic_recebimento_doca] CHAR (1)     NULL,
    [ic_padrao_doca]      CHAR (1)     NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Doca] PRIMARY KEY CLUSTERED ([cd_doca] ASC) WITH (FILLFACTOR = 90)
);

