CREATE TABLE [dbo].[Doc_Instrucao_Banco_Composicao] (
    [cd_doc_instrucao_banco]    INT          NOT NULL,
    [cd_item_instrucao_banco]   INT          NOT NULL,
    [dt_instrucao_banco_comp]   DATETIME     NULL,
    [vl_instrucao_banco_compos] FLOAT (53)   NULL,
    [nm_instrucao_banco_compos] VARCHAR (30) NULL,
    [cd_instrucao]              INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Doc_Instrucao_Banco_Composicao] PRIMARY KEY CLUSTERED ([cd_doc_instrucao_banco] ASC, [cd_item_instrucao_banco] ASC) WITH (FILLFACTOR = 90)
);

