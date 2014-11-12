CREATE TABLE [dbo].[Irregularidade_Recebimento] (
    [cd_irregularidade]     INT          NOT NULL,
    [nm_irregularidade]     VARCHAR (40) NULL,
    [sg_irregularidade]     CHAR (10)    NULL,
    [ic_pad_irregularidade] CHAR (1)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [nm_obs_irregularidade] VARCHAR (40) NULL,
    CONSTRAINT [PK_Irregularidade_Recebimento] PRIMARY KEY CLUSTERED ([cd_irregularidade] ASC) WITH (FILLFACTOR = 90)
);

