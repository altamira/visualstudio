CREATE TABLE [dbo].[Grupo_Operacao_Fiscal] (
    [cd_grupo_operacao_fiscal]  INT          NOT NULL,
    [nm_grupo_operacao_fiscal]  VARCHAR (50) NOT NULL,
    [sg_grupo_operacao_fiscal]  CHAR (10)    NOT NULL,
    [cd_digito_grupo]           INT          NOT NULL,
    [cd_tipo_operacao_fiscal]   INT          NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [ic_estado_grupo_op_fiscal] CHAR (1)     NULL,
    [ic_procedencia_op_fiscal]  CHAR (1)     NULL,
    [ic_importacao_op_fiscal]   CHAR (1)     NULL,
    [ic_exportacao_op_fiscal]   CHAR (1)     NULL,
    [ic_servico_grupo]          CHAR (1)     NULL,
    [ic_nfe_grupo_operacao]     CHAR (1)     NULL,
    CONSTRAINT [PK_Grupo_operacao_fiscal] PRIMARY KEY CLUSTERED ([cd_grupo_operacao_fiscal] ASC) WITH (FILLFACTOR = 90)
);

