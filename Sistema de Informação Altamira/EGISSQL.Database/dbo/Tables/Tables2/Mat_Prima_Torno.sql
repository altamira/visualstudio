CREATE TABLE [dbo].[Mat_Prima_Torno] (
    [cd_mat_prima_torno] INT          NOT NULL,
    [nm_mat_prima_torno] VARCHAR (15) NOT NULL,
    [sg_mat_prima_torno] CHAR (10)    NOT NULL,
    [cd_usuario]         INT          NOT NULL,
    [dt_usuario]         DATETIME     NOT NULL,
    CONSTRAINT [PK_Mat_Prima_Torno] PRIMARY KEY CLUSTERED ([cd_mat_prima_torno] ASC) WITH (FILLFACTOR = 90)
);

