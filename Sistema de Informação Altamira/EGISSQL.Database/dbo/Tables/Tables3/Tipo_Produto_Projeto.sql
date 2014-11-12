CREATE TABLE [dbo].[Tipo_Produto_Projeto] (
    [cd_tipo_produto_projeto] INT          NOT NULL,
    [nm_tipo_produto_projeto] VARCHAR (40) NULL,
    [sg_tipo_produto_projeto] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_requisicao_projeto]   CHAR (1)     NULL,
    [ic_procfab_projeto]      CHAR (1)     NULL,
    [ic_req_interna_projeto]  CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Produto_Projeto] PRIMARY KEY CLUSTERED ([cd_tipo_produto_projeto] ASC) WITH (FILLFACTOR = 90)
);

