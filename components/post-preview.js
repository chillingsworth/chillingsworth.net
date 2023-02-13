import Head from 'next/head'
import Image from 'next/image'
import { useRouter } from 'next/router'
import { Inter } from '@next/font/google'
import styles from '../styles/Home.module.css'

const inter = Inter({ subsets: ['latin'] })

export default function PostPreview(props) {

  let router= useRouter()

  function goToPost() {   
    router.push(props.link)
  }

  return (
    <div className={styles.post_preview_body} onClick={goToPost}>
      <div>
        Post #{props.id}
      </div>
      <h1>
        {props.header}
      </h1>
      <h2>
        {props.body}
      </h2>
    </div>
  )
}
