CREATE TABLE [dbo].[Observacao_Corpo_Nota_Fiscal] (
    [cd_obs_padrao_nf]      INT          NOT NULL,
    [ic_tipo_obs_padrao_nf] CHAR (1)     NOT NULL,
    [nm_obs_padrao_nf]      VARCHAR (30) NOT NULL,
    [ds_obs_padrao_nf]      TEXT         NOT NULL,
    [qt_col_obs_padrao_nf]  FLOAT (53)   NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL
);

