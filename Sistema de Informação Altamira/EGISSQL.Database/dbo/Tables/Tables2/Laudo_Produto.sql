CREATE TABLE [dbo].[Laudo_Produto] (
    [cd_laudo_produto]       INT          NOT NULL,
    [nm_laudo_produto]       VARCHAR (40) NULL,
    [sg_laudo_produto]       CHAR (10)    NULL,
    [ic_pad_laudo_produto]   CHAR (1)     NULL,
    [ic_ativo_laudo_produto] CHAR (1)     NULL,
    [ds_laudo_produto]       TEXT         NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Laudo_Produto] PRIMARY KEY CLUSTERED ([cd_laudo_produto] ASC) WITH (FILLFACTOR = 90)
);

