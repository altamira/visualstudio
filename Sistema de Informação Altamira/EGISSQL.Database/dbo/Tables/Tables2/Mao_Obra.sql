CREATE TABLE [dbo].[Mao_Obra] (
    [cd_mao_obra]              INT          NOT NULL,
    [nm_mao_obra]              VARCHAR (30) NOT NULL,
    [sg_mao_obra]              CHAR (10)    NOT NULL,
    [cd_tipo_mao_obra]         INT          NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [vl_mao_obra]              FLOAT (53)   NULL,
    [vl_custo_mao_obra]        FLOAT (53)   NULL,
    [ds_mao_obra]              TEXT         NULL,
    [vl_custo_mao_obra_padrao] FLOAT (53)   NULL,
    CONSTRAINT [PK_Mao_Obra] PRIMARY KEY CLUSTERED ([cd_mao_obra] ASC) WITH (FILLFACTOR = 90)
);

