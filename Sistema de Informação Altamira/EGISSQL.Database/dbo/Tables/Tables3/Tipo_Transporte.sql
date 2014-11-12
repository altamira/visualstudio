CREATE TABLE [dbo].[Tipo_Transporte] (
    [cd_tipo_transporte]        INT          NOT NULL,
    [nm_tipo_transporte]        VARCHAR (30) NOT NULL,
    [sg_tipo_transporte]        CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_tipo_seguro]            INT          NULL,
    [pc_seguro_tipo_transporte] FLOAT (53)   NULL,
    [cd_siscomex]               INT          NULL,
    [nm_via_tipo_transporte]    VARCHAR (15) NULL,
    [sg_imp_tipo_transporte]    CHAR (2)     NULL,
    [ic_padrao_exp_transporte]  CHAR (1)     NULL,
    [ic_padrao_imp_transporte]  CHAR (1)     NULL,
    [cd_sped_fiscal]            VARCHAR (15) NULL,
    CONSTRAINT [PK_Tipo_transporte] PRIMARY KEY CLUSTERED ([cd_tipo_transporte] ASC) WITH (FILLFACTOR = 90)
);

