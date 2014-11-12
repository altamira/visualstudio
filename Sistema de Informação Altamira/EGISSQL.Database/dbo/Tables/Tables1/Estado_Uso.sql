CREATE TABLE [dbo].[Estado_Uso] (
    [cd_estado_uso] INT          NOT NULL,
    [nm_estado_uso] VARCHAR (30) NULL,
    [sg_estado_uso] CHAR (10)    NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Estado_Uso] PRIMARY KEY CLUSTERED ([cd_estado_uso] ASC) WITH (FILLFACTOR = 90)
);

