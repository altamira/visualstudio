CREATE TABLE [dbo].[Instrucao_Banco_Composicao] (
    [cd_instrucao_banco]        INT          NOT NULL,
    [cd_item_instrucao_banco]   INT          NOT NULL,
    [vl_instrucao_banco_compos] FLOAT (53)   NOT NULL,
    [dt_instrucao_banco_comp]   DATETIME     NOT NULL,
    [nm_instrucao_banco_compos] VARCHAR (30) NOT NULL,
    [ic_valor_instrucao]        CHAR (1)     NOT NULL,
    [ic_data_instrucao]         CHAR (1)     NOT NULL,
    [cd_instrucao]              INT          NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL
);

