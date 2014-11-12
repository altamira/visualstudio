CREATE TABLE [dbo].[Tipo_Seguro] (
    [cd_tipo_seguro]         INT           NOT NULL,
    [nm_tipo_seguro]         VARCHAR (30)  NOT NULL,
    [sg_tipo_seguro]         CHAR (10)     NOT NULL,
    [pc_tipo_seguro]         FLOAT (53)    NOT NULL,
    [cd_usuario]             INT           NOT NULL,
    [dt_usuario]             DATETIME      NOT NULL,
    [ic_pad_exp_tipo_seguro] CHAR (1)      NULL,
    [ic_pad_imp_tipo_seguro] CHAR (1)      NULL,
    [ds_mensagem_seguro]     TEXT          NULL,
    [nm_mensagem_seguro]     VARCHAR (100) NULL,
    CONSTRAINT [PK_Tipo_Seguro] PRIMARY KEY CLUSTERED ([cd_tipo_seguro] ASC) WITH (FILLFACTOR = 90)
);

