//
//  main.m
//  RSTest1
//
//  Created by Eden on 2/3/2021.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
#include "cJSON.h"
#define ROW 16
#define COL 2

void doit(char *text)
{
    char *out;cJSON *json;
    
    json=cJSON_Parse(text);
    if (!json) {printf("Error before: [%s]\n",cJSON_GetErrorPtr());}
    else
    {
        out=cJSON_Print(json);
        cJSON_Delete(json);
        printf("%s\n",out);
        free(out);
    }
}

/* Read a file, parse, render back, etc. */
void dofile(char *filename)
{
    FILE *f;long len;char *data;
    
    f=fopen(filename,"rb");fseek(f,0,SEEK_END);len=ftell(f);fseek(f,0,SEEK_SET);
    data=(char*)malloc(len+1);fread(data,1,len,f);fclose(f);
    doit(data);
    free(data);
}

/* Used by some code below as an example datatype. */
struct record {const char *precision;double lat,lon;const char *address,*city,*state,*zip,*country; };

/* Create a bunch of objects as demonstration. */
void create_objects()
{
    cJSON *root,*fmt,*img,*thm,*fld;char *out;int i;    /* declare a few. */
    /* Our "days of the week" array: */
    const char *strings[7]={"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
    /* Our matrix: */
    int numbers[3][3]={{0,-1,0},{1,0,0},{0,0,1}};
    /* Our "gallery" item: */
    int ids[4]={116,943,234,38793};
    /* Our array of "records": */
    struct record fields[2]={
        {"zip",37.7668,-1.223959e+2,"","SAN FRANCISCO","CA","94107","US"},
        {"zip",37.371991,-1.22026e+2,"","SUNNYVALE","CA","94085","US"}};

    /* Here we construct some JSON standards, from the JSON site. */
    
    /* Our "Video" datatype: */
    root=cJSON_CreateObject();
    cJSON_AddItemToObject(root, "name", cJSON_CreateString("Jack (\"Bee\") Nimble"));
    cJSON_AddItemToObject(root, "format", fmt=cJSON_CreateObject());
    cJSON_AddStringToObject(fmt,"type",        "rect");
    cJSON_AddNumberToObject(fmt,"width",        1920);
    cJSON_AddNumberToObject(fmt,"height",        1080);
    cJSON_AddFalseToObject (fmt,"interlace");
    cJSON_AddNumberToObject(fmt,"frame rate",    24);
    
    out=cJSON_Print(root);    cJSON_Delete(root);    printf("%s\n",out);    free(out);    /* Print to text, Delete the cJSON, print it, release the string. */

    /* Our "days of the week" array: */
    root=cJSON_CreateStringArray(strings,7);

    out=cJSON_Print(root);    cJSON_Delete(root);    printf("%s\n",out);    free(out);

    /* Our matrix: */
    root=cJSON_CreateArray();
    for (i=0;i<3;i++) cJSON_AddItemToArray(root,cJSON_CreateIntArray(numbers[i],3));

/*    cJSON_ReplaceItemInArray(root,1,cJSON_CreateString("Replacement")); */
    
    out=cJSON_Print(root);    cJSON_Delete(root);    printf("%s\n",out);    free(out);


    /* Our "gallery" item: */
    root=cJSON_CreateObject();
    cJSON_AddItemToObject(root, "Image", img=cJSON_CreateObject());
    cJSON_AddNumberToObject(img,"Width",800);
    cJSON_AddNumberToObject(img,"Height",600);
    cJSON_AddStringToObject(img,"Title","View from 15th Floor");
    cJSON_AddItemToObject(img, "Thumbnail", thm=cJSON_CreateObject());
    cJSON_AddStringToObject(thm, "Url", "http:/*www.example.com/image/481989943");
    cJSON_AddNumberToObject(thm,"Height",125);
    cJSON_AddStringToObject(thm,"Width","100");
    cJSON_AddItemToObject(img,"IDs", cJSON_CreateIntArray(ids,4));

    out=cJSON_Print(root);    cJSON_Delete(root);    printf("%s\n",out);    free(out);

    /* Our array of "records": */

    root=cJSON_CreateArray();
    for (i=0;i<2;i++)
    {
        cJSON_AddItemToArray(root,fld=cJSON_CreateObject());
        cJSON_AddStringToObject(fld, "precision", fields[i].precision);
        cJSON_AddNumberToObject(fld, "Latitude", fields[i].lat);
        cJSON_AddNumberToObject(fld, "Longitude", fields[i].lon);
        cJSON_AddStringToObject(fld, "Address", fields[i].address);
        cJSON_AddStringToObject(fld, "City", fields[i].city);
        cJSON_AddStringToObject(fld, "State", fields[i].state);
        cJSON_AddStringToObject(fld, "Zip", fields[i].zip);
        cJSON_AddStringToObject(fld, "Country", fields[i].country);
    }
    
/*    cJSON_ReplaceItemInObject(cJSON_GetArrayItem(root,1),"City",cJSON_CreateIntArray(ids,4)); */
    
    out=cJSON_Print(root);    cJSON_Delete(root);    printf("%s\n",out);    free(out);

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
//        int arr1D[32];
//        int arr2D[ROW][COL];
//        int arr3D[16];
//        int i,j;
//        for (int k  = 0; k < 32; k++ )
//        {
//            arr1D [k] = k + 1;
//
//        }
//        //一维维整型数组转换为二维整型数组
//        for(i=0;i < 16;i++)
//        {
//            for(j=0;j < 2;j++)
//            {
//                arr2D[i][j] = arr1D[i*2+j];
//                printf("---%d\n", arr1D[i*2+j]);
//            }
//        }
//        //二维整型数组打印显示
//        for( i = 0; i < ROW; i++)
//        {
//            for(j=0;j<1;j++)
//            {
//                // printf("%d  ", arr2D[i][j]);
//                arr3D[i] = arr2D[i][0];
//                printf("***%d  ", arr3D[i]);
//                printf("%d  ",  arr2D[i][1]);
//            }
//            printf("\n");
//        }
//        system("pause");
//
//        int arr1D[16];
//        int arr2D[16];
//        int arr3D[32];
//        int i,j;
//        for (int i  = 0; i < 16; i++)
//        {
//            arr1D [i] = i;
//            printf("数组1----%d\n",arr1D [i]);
//        }
//
//        for (int i  = 0; i < 16; i++)
//        {
//            arr2D [i] = i+200;
//            printf("数组2----%d\n",arr2D [i]);
//        }
//
//        int m = 0;
//        int n = 0;
//        for (int j = 0; j < 32; j++ )
//        {
//            if (j%2 == 0) {
//                arr3D[j] = arr1D[m];
//                m++;
//            }
//            else
//            {
//                arr3D[j] = arr2D[n];
//                n++;
//            }
//
//        }
//        printf("****************************************");
//        for (int i = 0; i < 32; i++)
//        {
//            printf("数组3----%d\n",arr3D [i]);
//        }
        
        char text1[]="{\n\"name\": \"Jack (\\\"Bee\\\") Nimble\", \n\"format\": {\"type\":       \"rect\", \n\"width\":      1920, \n\"height\":     1080, \n\"interlace\":  false,\"frame rate\": 24\n}\n}";
        char text2[]="[\"Sunday\", \"Monday\", \"Tuesday\", \"Wednesday\", \"Thursday\", \"Friday\", \"Saturday\"]";
        char text3[]="[\n    [0, -1, 0],\n    [1, 0, 0],\n    [0, 0, 1]\n    ]\n";
        char text4[]="{\n        \"Image\": {\n            \"Width\":  800,\n            \"Height\": 600,\n            \"Title\":  \"View from 15th Floor\",\n            \"Thumbnail\": {\n                \"Url\":    \"http:/*www.example.com/image/481989943\",\n                \"Height\": 125,\n                \"Width\":  \"100\"\n            },\n            \"IDs\": [116, 943, 234, 38793]\n        }\n    }";
        char text5[]="[\n     {\n     \"precision\": \"zip\",\n     \"Latitude\":  37.7668,\n     \"Longitude\": -122.3959,\n     \"Address\":   \"\",\n     \"City\":      \"SAN FRANCISCO\",\n     \"State\":     \"CA\",\n     \"Zip\":       \"94107\",\n     \"Country\":   \"US\"\n     },\n     {\n     \"precision\": \"zip\",\n     \"Latitude\":  37.371991,\n     \"Longitude\": -122.026020,\n     \"Address\":   \"\",\n     \"City\":      \"SUNNYVALE\",\n     \"State\":     \"CA\",\n     \"Zip\":       \"94085\",\n     \"Country\":   \"US\"\n     }\n     ]";
        
        char text6[] = "{\n\"command\":\"usb\",\n\"result\":0\n}";

        /* Process each json textblock by parsing, then rebuilding: */
        doit(text6);
       // doit(text2);
      //  doit(text3);
      //  doit(text4);
      //  doit(text5);

        /* Parse standard testfiles: */
    /*    dofile("../../tests/test1"); */
    /*    dofile("../../tests/test2"); */
    /*    dofile("../../tests/test3"); */
    /*    dofile("../../tests/test4"); */
    /*    dofile("../../tests/test5"); */

        /* Now some samplecode for building objects concisely: */
      //  create_objects();
   }
    return 0;
}
