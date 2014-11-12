CREATE TABLE [dbo].[Parametro_Operacao_Fiscal] (
    [cd_parametro_op_fiscal]    INT          NOT NULL,
    [nm_parametro_op_fiscal]    VARCHAR (30) NOT NULL,
    [cd_operacao_fiscal]        INT          NOT NULL,
    [cd_destinacao_produto]     INT          NOT NULL,
    [nm_obs_parametro_opfiscal] VARCHAR (40) NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [ic_estado_op_fiscal]       CHAR (1)     NULL,
    [ic_parametro_op_fiscal]    CHAR (1)     NULL,
    CONSTRAINT [PK_Parametro_Operacao_Fiscal] PRIMARY KEY CLUSTERED ([cd_parametro_op_fiscal] ASC, [cd_operacao_fiscal] ASC, [cd_destinacao_produto] ASC) WITH (FILLFACTOR = 90)
);

