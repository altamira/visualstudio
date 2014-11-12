CREATE TABLE [dbo].[Tipo_Rateio] (
    [cd_tipo_rateio] INT          NOT NULL,
    [nm_tipo_rateio] VARCHAR (30) NOT NULL,
    [sg_tipo_rateio] CHAR (10)    NOT NULL,
    [ic_tipo_rateio] CHAR (1)     NOT NULL,
    [cd_usuario]     INT          NOT NULL,
    [dt_usuario]     DATETIME     NOT NULL,
    [ds_tipo_rateio] TEXT         NOT NULL,
    CONSTRAINT [PK_Tipo_Rateio] PRIMARY KEY CLUSTERED ([cd_tipo_rateio] ASC) WITH (FILLFACTOR = 90)
);

