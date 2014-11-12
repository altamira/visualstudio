CREATE TABLE [dbo].[Tipo_Risco_Comex] (
    [cd_tipo_risco_comex] INT          NOT NULL,
    [nm_tipo_risco_comex] VARCHAR (40) NOT NULL,
    [sg_tipo_risco_comex] CHAR (10)    NOT NULL,
    [ds_tipo_risco_comex] TEXT         NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Risco_Comex] PRIMARY KEY CLUSTERED ([cd_tipo_risco_comex] ASC) WITH (FILLFACTOR = 90)
);

