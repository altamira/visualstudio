CREATE TABLE [dbo].[Finalidade_Adiantamento] (
    [cd_finalidade_adiantamento]     INT          NOT NULL,
    [nm_finalidade_adiantamento]     VARCHAR (40) NULL,
    [sg_finalidade_adiantamento]     CHAR (10)    NULL,
    [qt_vencimento_finalidade]       FLOAT (53)   NULL,
    [cd_usuario]                     INT          NULL,
    [dt_usuario]                     DATETIME     NULL,
    [ic_pad_finalidade_adiantamento] CHAR (1)     NULL,
    [ic_tipo_finalidade]             CHAR (1)     NULL,
    CONSTRAINT [PK_Finalidade_Adiantamento] PRIMARY KEY CLUSTERED ([cd_finalidade_adiantamento] ASC) WITH (FILLFACTOR = 90)
);

