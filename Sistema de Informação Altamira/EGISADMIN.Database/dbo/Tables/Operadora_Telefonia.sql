CREATE TABLE [dbo].[Operadora_Telefonia] (
    [cd_operadora]         INT          NOT NULL,
    [nm_operadoroa]        VARCHAR (20) NOT NULL,
    [sg_operadora]         CHAR (5)     NOT NULL,
    [cd_servico_operadora] CHAR (2)     NOT NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [CD_USUARIO_ATUALIZA]  INT          NULL,
    [DT_ATUALIZA]          DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([cd_operadora] ASC) WITH (FILLFACTOR = 90)
);

