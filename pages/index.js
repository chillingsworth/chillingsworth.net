import Head from 'next/head'
import Image from 'next/image'
import { useRouter } from 'next/router'
import { Inter } from '@next/font/google'
import styles from '../styles/Home.module.css'
import posts from '../postdata/posts.json';
import PostPreview from '../components/post-preview'
import React, { useState } from 'react';
import Header from '../components/header'

const inter = Inter({ subsets: ['latin'] })

export default function Home() {

  let router= useRouter()

  function redirectAbout() {   
    router.push('/about')
  }

  return (
    <>
      <Header></Header>
      <div className={styles.body_header_item}>
        <div className={styles.about_area}>
          {posts.posts.map((post)=>{
            return <PostPreview key={post.id} id={post.id} header={post.header} body={post.body} link={post.link}></PostPreview>
          })}
        </div>
      </div>
    </>
  )
}
