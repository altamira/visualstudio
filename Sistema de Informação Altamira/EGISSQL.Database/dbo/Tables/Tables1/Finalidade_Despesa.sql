CREATE TABLE [dbo].[Finalidade_Despesa] (
    [cd_finalidade_despesa]     INT          NOT NULL,
    [nm_finalidade_despesa]     VARCHAR (40) NOT NULL,
    [sg_finalidade_despesa]     CHAR (10)    NULL,
    [ic_pad_finalidade_despesa] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Finalidade_Despesa] PRIMARY KEY CLUSTERED ([cd_finalidade_despesa] ASC) WITH (FILLFACTOR = 90)
);

