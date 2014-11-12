CREATE TABLE [dbo].[Tipo_Diaria_Hotel] (
    [cd_tipo_diaria]       INT          NOT NULL,
    [nm_tipo_diaria]       VARCHAR (40) NULL,
    [sg_tipo_diaria]       CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [vl_tipo_diaria_hotel] FLOAT (53)   NULL,
    [cd_moeda]             INT          NULL,
    CONSTRAINT [PK_Tipo_Diaria_Hotel] PRIMARY KEY CLUSTERED ([cd_tipo_diaria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Diaria_Hotel_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

