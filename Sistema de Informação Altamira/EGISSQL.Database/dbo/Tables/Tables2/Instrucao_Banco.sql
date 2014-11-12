CREATE TABLE [dbo].[Instrucao_Banco] (
    [cd_banco]                 INT          NOT NULL,
    [cd_instrucao]             INT          NOT NULL,
    [cd_instrucao_banco]       INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_obs_instrucao_banco]   VARCHAR (30) NULL,
    [ic_data_instrucao_banco]  CHAR (1)     NULL,
    [ic_valor_instrucao_banco] CHAR (1)     NULL
);

