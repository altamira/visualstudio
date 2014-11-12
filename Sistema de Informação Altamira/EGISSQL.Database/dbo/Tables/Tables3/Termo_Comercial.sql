CREATE TABLE [dbo].[Termo_Comercial] (
    [cd_termo_comercial]           INT          NOT NULL,
    [nm_termo_comercial]           VARCHAR (40) NOT NULL,
    [sg_termo_comercial]           CHAR (10)    NOT NULL,
    [ds_termo_comercial]           TEXT         NULL,
    [ic_seguro_termo_comercial]    CHAR (1)     NOT NULL,
    [ic_frete_termo_comercial]     CHAR (1)     NOT NULL,
    [cd_usuario]                   INT          NOT NULL,
    [dt_usuario]                   DATETIME     NOT NULL,
    [ic_pad_termo_comercial]       CHAR (1)     NULL,
    [ic_padrao_exp_termo]          CHAR (1)     NULL,
    [ic_padrao_imp_termo]          CHAR (1)     NULL,
    [nm_obs_termo_comercial]       VARCHAR (50) NULL,
    [ic_capatazia_termo_comercial] CHAR (1)     NULL,
    [ic_tipo_local_porto]          CHAR (1)     NULL,
    CONSTRAINT [PK_Termo_Comercial] PRIMARY KEY CLUSTERED ([cd_termo_comercial] ASC) WITH (FILLFACTOR = 90)
);

